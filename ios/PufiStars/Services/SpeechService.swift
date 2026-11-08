import AVFoundation

/// Vocea nativă: folosește vocile Premium/Enhanced instalate pe iPad (Setări > Accesibilitate > Conținut vorbit > Voci).
@MainActor
final class SpeechService: NSObject, @preconcurrency AVSpeechSynthesizerDelegate {
    private let synth = AVSpeechSynthesizer()
    private var completions: [ObjectIdentifier: (Bool) -> Void] = [:]
    private var wordHandlers: [ObjectIdentifier: (NSRange) -> Void] = [:]

    static let locales: [String: String] = [
        "ro": "ro-RO", "de": "de-DE", "en": "en-GB", "fr": "fr-FR", "it": "it-IT", "es": "es-ES",
        "pt": "pt-BR", "nl": "nl-NL", "pl": "pl-PL", "hu": "hu-HU", "uk": "uk-UA", "ru": "ru-RU"
    ]

    override init() {
        super.init()
        synth.delegate = self
        Self.usePlaybackSession()
    }

    static func usePlaybackSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        try? session.setActive(true)
    }

    func voice(for lang: String) -> AVSpeechSynthesisVoice? {
        let code = Self.locales[lang] ?? lang
        let all = AVSpeechSynthesisVoice.speechVoices()
        var candidates = all.filter { $0.language == code }
        if candidates.isEmpty { candidates = all.filter { $0.language.hasPrefix(String(code.prefix(2))) } }
        func score(_ v: AVSpeechSynthesisVoice) -> Int {
            var s = 0
            switch v.quality {
            case .premium: s += 300
            case .enhanced: s += 200
            default: s += 100
            }
            if v.voiceTraits.contains(.isNoveltyVoice) { s -= 500 }
            return s
        }
        return candidates.max { score($0) < score($1) } ?? AVSpeechSynthesisVoice(language: code)
    }

    func info(lang: String) -> [String: Any] {
        guard let v = voice(for: lang) else { return ["name": "", "quality": "none"] }
        let q: String
        switch v.quality {
        case .premium: q = "premium"
        case .enhanced: q = "enhanced"
        default: q = "default"
        }
        return ["name": v.name, "quality": q, "language": v.language]
    }

    func speak(_ text: String, lang: String, rate: Float, onWord: ((NSRange) -> Void)?, completion: @escaping (Bool) -> Void) {
        if synth.isSpeaking || synth.isPaused { synth.stopSpeaking(at: .immediate) }
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { completion(true); return }
        let u: AVSpeechUtterance
        // On some voices IPA changes delegate offsets after the annotated word.
        // Karaoke uses UTF-16 ranges in the original text, so keep that utterance plain.
        if onWord == nil, let attributed = Self.withPronunciation(text, lang: lang) {
            u = AVSpeechUtterance(attributedString: attributed)
        } else {
            u = AVSpeechUtterance(string: text)
        }
        u.voice = voice(for: lang)
        u.rate = AVSpeechUtteranceDefaultSpeechRate * max(0.5, min(1.3, rate))
        u.preUtteranceDelay = 0.02
        let key = ObjectIdentifier(u)
        completions[key] = completion
        if let onWord { wordHandlers[key] = onWord }
        Self.usePlaybackSession()
        synth.speak(u)
    }

    /// Pronunții fixate cu IPA: vocea română citea „ora” (ora două) ca „oră”.
    static let ipaFixes: [String: [String: String]] = [
        "ro": ["ora": "ˈora", "Ora": "ˈora"]
    ]

    static func withPronunciation(_ text: String, lang: String) -> NSAttributedString? {
        guard let fixes = ipaFixes[lang] else { return nil }
        let attr = NSMutableAttributedString(string: text)
        let ns = text as NSString
        var changed = false
        for (word, ipa) in fixes {
            guard let re = try? NSRegularExpression(pattern: "(?<![\\p{L}])" + NSRegularExpression.escapedPattern(for: word) + "(?![\\p{L}])") else { continue }
            for m in re.matches(in: text, range: NSRange(location: 0, length: ns.length)) {
                attr.addAttribute(NSAttributedString.Key(AVSpeechSynthesisIPANotationAttribute), value: ipa, range: m.range)
                changed = true
            }
        }
        return changed ? attr : nil
    }

    func stop() {
        if synth.isSpeaking || synth.isPaused { synth.stopSpeaking(at: .immediate) }
    }

    private func finish(_ u: AVSpeechUtterance, _ ok: Bool) {
        let key = ObjectIdentifier(u)
        wordHandlers[key] = nil
        if let c = completions.removeValue(forKey: key) { c(ok) }
    }

    func speechSynthesizer(_ s: AVSpeechSynthesizer, didFinish u: AVSpeechUtterance) { finish(u, true) }
    func speechSynthesizer(_ s: AVSpeechSynthesizer, didCancel u: AVSpeechUtterance) { finish(u, false) }
    func speechSynthesizer(_ s: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance u: AVSpeechUtterance) {
        wordHandlers[ObjectIdentifier(u)]?(characterRange)
    }
}
