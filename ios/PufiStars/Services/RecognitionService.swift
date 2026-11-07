import AVFoundation
import Speech

struct RecognitionFailure: Error, LocalizedError, Equatable, Sendable {
    let reason: String
    var errorDescription: String? { reason }
}

// The audio tap owns these objects until the engine stops and the tap is removed.
// AVAudioEngine serializes its tap callbacks; no main-actor state is touched here.
private final class RecognitionAudioSink: @unchecked Sendable {
    private let request: SFSpeechAudioBufferRecognitionRequest
    private let file: AVAudioFile?

    init(request: SFSpeechAudioBufferRecognitionRequest, file: AVAudioFile?) {
        self.request = request
        self.file = file
    }

    nonisolated func append(_ buffer: AVAudioPCMBuffer) {
        request.append(buffer)
        try? file?.write(from: buffer)
    }
}

/// Shared by read-aloud and parent dictation. Only lifecycle/UI callbacks use the main actor.
@MainActor
final class RecognitionService {
    private let engine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var hasTap = false
    private var sessionID = UUID()

    var lastURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("lastReading.caf")
    }

    nonisolated static func speechPermission(_ status: SFSpeechRecognizerAuthorizationStatus) -> String {
        switch status {
        case .authorized: return "authorized"
        case .denied: return "denied"
        case .restricted: return "restricted"
        case .notDetermined: return "notDetermined"
        @unknown default: return "notDetermined"
        }
    }

    static func permissions() -> [String: String] {
        let mic: String
        switch AVAudioApplication.shared.recordPermission {
        case .granted: mic = "granted"
        case .denied: mic = "denied"
        case .undetermined: mic = "undetermined"
        @unknown default: mic = "undetermined"
        }
        return ["speech": speechPermission(SFSpeechRecognizer.authorizationStatus()), "mic": mic]
    }

    nonisolated static func permissionFailure(speech: String, mic: String) -> RecognitionFailure? {
        guard speech == "authorized" else { return RecognitionFailure(reason: "speech-" + speech) }
        return mic == "granted" ? nil : RecognitionFailure(reason: "mic-denied")
    }

    static func authorize(_ done: @escaping @MainActor @Sendable (RecognitionFailure?) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            let speech = speechPermission(status)
            guard status == .authorized else {
                DispatchQueue.main.async { done(RecognitionFailure(reason: "speech-" + speech)) }
                return
            }
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async { done(permissionFailure(speech: speech, mic: granted ? "granted" : "denied")) }
            }
        }
    }

    private func recognizer(_ lang: String) -> SFSpeechRecognizer? {
        SFSpeechRecognizer(locale: Locale(identifier: SpeechService.locales[lang] ?? lang))
    }

    func availability(lang: String) -> [String: Any] {
        guard let r = recognizer(lang) else { return ["available": false, "onDevice": false] }
        return ["available": r.isAvailable, "onDevice": r.supportsOnDeviceRecognition]
    }

    nonisolated static func validFormat(_ format: AVAudioFormat) -> Bool {
        format.sampleRate.isFinite && format.sampleRate > 0 && format.channelCount > 0
    }

    nonisolated static func shouldRetryOnNetwork(onDevice: Bool, hasText: Bool, elapsed: TimeInterval) -> Bool {
        onDevice && !hasText && elapsed <= 3
    }

    func start(lang: String, words: [String],
               onText: @escaping (String, Bool) -> Void,
               onEnd: @escaping (String?) -> Void) throws {
        try begin(lang: lang, words: words, forceNetwork: false, onText: onText, onEnd: onEnd)
    }

    private func begin(lang: String, words: [String], forceNetwork: Bool,
                       onText: @escaping (String, Bool) -> Void,
                       onEnd: @escaping (String?) -> Void) throws {
        stop()
        let locale = SpeechService.locales[lang] ?? lang
        guard let rec = recognizer(lang) else { throw RecognitionFailure(reason: "no-recognizer-" + locale) }
        guard rec.isAvailable else { throw RecognitionFailure(reason: "unavailable-" + locale) }
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothHFP])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            SpeechService.usePlaybackSession()
            throw RecognitionFailure(reason: "session:" + error.localizedDescription)
        }

        // Query the format only after activating the recording session. Some routes
        // report a zero output format but a usable input format on the first start.
        let input = engine.inputNode
        var format = input.outputFormat(forBus: 0)
        if !Self.validFormat(format) { format = input.inputFormat(forBus: 0) }
        guard Self.validFormat(format) else {
            SpeechService.usePlaybackSession()
            throw RecognitionFailure(reason: "format:\(format.sampleRate)Hz")
        }

        let req = SFSpeechAudioBufferRecognitionRequest()
        req.shouldReportPartialResults = true
        req.taskHint = .dictation
        req.contextualStrings = Array(words.prefix(100))
        req.addsPunctuation = false
        let onDevice = rec.supportsOnDeviceRecognition && !forceNetwork
        req.requiresOnDeviceRecognition = onDevice
        request = req
        try? FileManager.default.removeItem(at: lastURL)
        let file = try? AVAudioFile(forWriting: lastURL, settings: format.settings)
        let sink = RecognitionAudioSink(request: req, file: file)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in sink.append(buffer) }
        hasTap = true
        engine.prepare()
        do { try engine.start() }
        catch {
            stop()
            throw RecognitionFailure(reason: "engine:" + error.localizedDescription)
        }

        let currentSession = sessionID
        let startedAt = Date()
        var hasText = false
        task = rec.recognitionTask(with: req) { [weak self] result, error in
            // Copy callback values before crossing to the main actor.
            let text = result?.bestTranscription.formattedString
            let isFinal = result?.isFinal ?? false
            let failure = error.map { "other:" + $0.localizedDescription }
            DispatchQueue.main.async { [weak self] in
                guard let self, self.sessionID == currentSession else { return }
                if let text, !text.isEmpty { hasText = true; onText(text, isFinal) }
                if let failure {
                    NSLog("Pufi ASR: %@", failure)
                    if Self.shouldRetryOnNetwork(onDevice: onDevice, hasText: hasText,
                                                 elapsed: Date().timeIntervalSince(startedAt)) {
                        NSLog("Pufi ASR: on-device failed immediately for %@; retry once with network allowed", locale)
                        do {
                            try self.begin(lang: lang, words: words, forceNetwork: true, onText: onText, onEnd: onEnd)
                            return
                        } catch {
                            let reason = (error as? RecognitionFailure)?.reason ?? "other:" + error.localizedDescription
                            NSLog("Pufi ASR: %@", reason)
                            self.stop()
                            onEnd(reason)
                            return
                        }
                    }
                    self.stop()
                    onEnd(failure)
                } else if isFinal {
                    self.stop()
                    onEnd(nil)
                }
            }
        }
    }

    func stop() {
        let wasActive = hasTap || request != nil || task != nil
        sessionID = UUID()
        engine.stop()
        if hasTap { engine.inputNode.removeTap(onBus: 0); hasTap = false }
        request?.endAudio()
        task?.cancel()
        task = nil
        request = nil
        if wasActive { SpeechService.usePlaybackSession() }
    }
}
