import AVFoundation
import Speech

/// Ascultă copilul cât citește și trimite textul recunoscut către joc (karaoke „Citesc cu voce”).
/// Înregistrează în paralel citirea, ca s-o poată asculta la final.
final class RecognitionService {
    private let engine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    var lastURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("lastReading.caf")
    }

    static func authorize(_ done: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else { DispatchQueue.main.async { done(false) }; return }
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async { done(granted) }
            }
        }
    }

    private func recognizer(_ lang: String) -> SFSpeechRecognizer? {
        SFSpeechRecognizer(locale: Locale(identifier: SpeechService.locales[lang] ?? lang))
    }

    /// `onDevice` = funcționează fără internet (audio nu pleacă de pe iPad).
    func availability(lang: String) -> [String: Any] {
        guard let r = recognizer(lang) else { return ["available": false, "onDevice": false] }
        return ["available": r.isAvailable, "onDevice": r.supportsOnDeviceRecognition]
    }

    func start(lang: String, words: [String],
               onText: @escaping (String, Bool) -> Void,
               onEnd: @escaping () -> Void) throws {
        stop()
        guard let rec = recognizer(lang), rec.isAvailable else {
            throw NSError(domain: "asr", code: 1)
        }
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        let req = SFSpeechAudioBufferRecognitionRequest()
        req.shouldReportPartialResults = true
        req.taskHint = .dictation
        req.contextualStrings = Array(words.prefix(100))
        req.addsPunctuation = false
        if rec.supportsOnDeviceRecognition { req.requiresOnDeviceRecognition = true }
        request = req

        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)
        try? FileManager.default.removeItem(at: lastURL)
        let file = try? AVAudioFile(forWriting: lastURL, settings: format.settings)
        input.removeTap(onBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            req.append(buffer)
            try? file?.write(from: buffer)
        }
        engine.prepare()
        try engine.start()

        task = rec.recognitionTask(with: req) { result, error in
            DispatchQueue.main.async {
                if let result { onText(result.bestTranscription.formattedString, result.isFinal) }
                if error != nil || (result?.isFinal ?? false) { onEnd() }
            }
        }
    }

    func stop() {
        if engine.isRunning {
            engine.stop()
            engine.inputNode.removeTap(onBus: 0)
        }
        request?.endAudio()
        task?.cancel()
        task = nil
        request = nil
        SpeechService.usePlaybackSession()
    }
}
