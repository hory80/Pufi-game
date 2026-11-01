import AVFoundation

/// Înregistrările părintelui („Bravo!”, „Super, campionule!”…). Rămân doar pe acest aparat.
final class RecorderService: NSObject, AVAudioPlayerDelegate {
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private var playDone: (() -> Void)?

    private var folder: URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("voices", isDirectory: true)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    private func url(_ key: String) -> URL {
        let safe = key.filter { $0.isLetter || $0.isNumber || $0 == "_" || $0 == "-" }
        return folder.appendingPathComponent((safe.isEmpty ? "voice" : safe) + ".m4a")
    }

    static func authorize(_ done: @escaping (Bool) -> Void) {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async { done(granted) }
        }
    }

    func start(key: String) -> Bool {
        stop()
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            let r = try AVAudioRecorder(url: url(key), settings: settings)
            r.record(forDuration: 12)
            recorder = r
            return true
        } catch {
            return false
        }
    }

    func stop() {
        if recorder?.isRecording == true { recorder?.stop() }
        recorder = nil
        SpeechService.usePlaybackSession()
    }

    func play(key: String, done: @escaping () -> Void) { play(url: url(key), done: done) }

    func play(url: URL, done: @escaping () -> Void) {
        player?.stop()
        guard FileManager.default.fileExists(atPath: url.path), let p = try? AVAudioPlayer(contentsOf: url) else { done(); return }
        SpeechService.usePlaybackSession()
        p.delegate = self
        player = p
        playDone = done
        p.play()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let d = playDone
        playDone = nil
        d?()
    }

    func list() -> [String] {
        let files = (try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)) ?? []
        return files.filter { $0.pathExtension == "m4a" }.map { $0.deletingPathExtension().lastPathComponent }.sorted()
    }

    func delete(key: String) {
        try? FileManager.default.removeItem(at: url(key))
    }
}
