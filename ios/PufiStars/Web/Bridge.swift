import SwiftUI
import WebKit
import UIKit

/// Cererea de „poartă pentru părinți” afișată ca foaie SwiftUI.
struct GateRequest: Identifiable {
    let id = UUID()
    let callId: Int
    let language: String
}

/// Legătura dintre jocul JavaScript și serviciile native.
/// JS: `await native.call('speak', {text, lang})`; evenimente: `native.on('asr.partial', fn)`.
@MainActor
final class Bridge: NSObject, ObservableObject, WKScriptMessageHandler {
    weak var webView: WKWebView?
    @Published var gateRequest: GateRequest?

    private let speech = SpeechService()
    private let recognition = RecognitionService()
    private let recorder = RecorderService()
    private let store = ProgressStore()
    private var recognitionGeneration = UUID()

    // MARK: JS -> Swift
    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any], let cmd = body["cmd"] as? String else { return }
        let id = body["id"] as? Int ?? 0
        let args = body["args"] as? [String: Any] ?? [:]
        handle(cmd, args, id)
    }

    private func handle(_ cmd: String, _ a: [String: Any], _ id: Int) {
        let lang = a["lang"] as? String ?? "ro"
        switch cmd {
        case "speak":
            stopRecognition()
            let text = a["text"] as? String ?? ""
            let rate = (a["rate"] as? Double).map { Float($0) } ?? 0.9
            let words = a["words"] as? Bool ?? false
            speech.speak(text, lang: lang, rate: rate,
                         onWord: words ? { [weak self] range in self?.emit("speak.word", ["loc": range.location, "len": range.length]) } : nil) { [weak self] finished in
                self?.reply(id, finished)
            }
        case "stopSpeak":
            speech.stop(); reply(id, true)
        case "voiceInfo":
            reply(id, speech.info(lang: lang))
        case "haptic":
            let style: UIImpactFeedbackGenerator.FeedbackStyle = (a["style"] as? String) == "heavy" ? .heavy : .light
            UIImpactFeedbackGenerator(style: style).impactOccurred(); reply(id, true)
        case "gate":
            gateRequest = GateRequest(callId: id, language: lang)

        // recunoașterea vocii (copilul citește cu voce tare)
        case "asr.available":
            reply(id, recognition.availability(lang: lang))
        case "asr.perm":
            reply(id, RecognitionService.permissions())
        case "openSettings":
            guard let url = URL(string: UIApplication.openSettingsURLString) else { reply(id, false); return }
            UIApplication.shared.open(url, options: [:]) { [weak self] opened in
                DispatchQueue.main.async { self?.reply(id, opened) }
            }
        case "asr.start":
            speech.stop()
            recorder.stop()
            stopRecognition()
            let generation = recognitionGeneration
            let words = a["words"] as? [String] ?? []
            RecognitionService.authorize { [weak self] failure in
                guard let self else { return }
                guard self.recognitionGeneration == generation else {
                    self.recognitionFailed(id, "other:cancelled")
                    return
                }
                if let failure { self.recognitionFailed(id, failure.reason); return }
                do {
                    try self.recognition.start(lang: lang, words: words,
                        onText: { [weak self] text, isFinal in self?.emit("asr.partial", ["text": text, "final": isFinal]) },
                        onEnd: { [weak self] reason in self?.emit("asr.end", reason.map { ["reason": $0] } ?? [:]) })
                    self.reply(id, true)
                } catch {
                    self.recognitionFailed(id, (error as? RecognitionFailure)?.reason ?? "other:" + error.localizedDescription)
                }
            }
        case "asr.stop":
            stopRecognition(); reply(id, true)
        case "asr.playLast":
            stopRecognition()
            recorder.play(url: recognition.lastURL) { [weak self] in self?.reply(id, true) }

        // vocea părintelui
        case "rec.start":
            speech.stop()
            stopRecognition()
            let key = a["key"] as? String ?? "praise1"
            RecorderService.authorize { [weak self] ok in
                guard let self else { return }
                self.reply(id, ok && self.recorder.start(key: key))
            }
        case "rec.stop":
            recorder.stop(); reply(id, true)
        case "rec.play":
            let key = a["key"] as? String ?? ""
            recorder.play(key: key) { [weak self] in self?.reply(id, true) }
        case "rec.list":
            reply(id, recorder.list())
        case "rec.delete":
            recorder.delete(key: a["key"] as? String ?? ""); reply(id, true)

        // cumpărături în aplicație
        case "iap.status":
            PurchaseService.shared.refresh { [weak self] premium in self?.reply(id, premium) }
        case "iap.price":
            PurchaseService.shared.price { [weak self] price in self?.reply(id, price ?? "") }
        case "iap.buy":
            PurchaseService.shared.buy { [weak self] ok in self?.reply(id, ok) }
        case "iap.restore":
            PurchaseService.shared.restore { [weak self] ok in self?.reply(id, ok) }

        // copie de siguranță a progresului (localStorage)
        case "store.get":
            reply(id, store.load() ?? "")
        case "store.set":
            store.save(a["snapshot"] as? String ?? ""); reply(id, true)

        default:
            reply(id, NSNull())
        }
    }

    private func stopRecognition() {
        recognitionGeneration = UUID()
        recognition.stop()
    }

    private func recognitionFailed(_ id: Int, _ reason: String) {
        NSLog("Pufi ASR: %@", reason)
        reply(id, ["ok": false, "reason": reason])
    }

    func finishGate(_ request: GateRequest, passed: Bool) {
        gateRequest = nil
        reply(request.callId, passed)
    }

    // MARK: Swift -> JS
    private func reply(_ id: Int, _ value: Any) {
        guard id > 0 else { return }
        send("window.__nativeResolve(\(id), \(json(value)))")
    }

    private func emit(_ event: String, _ payload: [String: Any]) {
        send("window.__nativeEvent(\(json(event)), \(json(payload)))")
    }

    private func send(_ js: String) {
        DispatchQueue.main.async { [weak self] in
            self?.webView?.evaluateJavaScript(js, completionHandler: nil)
        }
    }

    private func json(_ value: Any) -> String {
        if let s = value as? String {
            let data = try? JSONSerialization.data(withJSONObject: [s], options: [])
            let arr = data.flatMap { String(data: $0, encoding: .utf8) } ?? "[\"\"]"
            return String(arr.dropFirst().dropLast())
        }
        if let b = value as? Bool { return b ? "true" : "false" }
        if value is NSNull { return "null" }
        if JSONSerialization.isValidJSONObject(value),
           let data = try? JSONSerialization.data(withJSONObject: value, options: []),
           let s = String(data: data, encoding: .utf8) { return s }
        return "null"
    }

    /// Scriptul injectat înainte de joc: creează `window.native`.
    static let jsShim = """
    (function(){
      if (window.native) return;
      var seq = 0, pend = {}, subs = {};
      window.NATIVE = { platform: 'ios' };
      window.native = {
        call: function(cmd, args){ return new Promise(function(res){ var id = ++seq; pend[id] = res;
          window.webkit.messageHandlers.native.postMessage({cmd: cmd, args: args || {}, id: id}); }); },
        on: function(ev, fn){ (subs[ev] = subs[ev] || []).push(fn); },
        off: function(ev, fn){ subs[ev] = (subs[ev] || []).filter(function(f){ return f !== fn; }); }
      };
      window.__nativeResolve = function(id, v){ var r = pend[id]; delete pend[id]; if (r) r(v); };
      window.__nativeEvent = function(ev, p){ (subs[ev] || []).forEach(function(f){ try { f(p); } catch(e){} }); };
      document.addEventListener('DOMContentLoaded', function(){
        var s = document.createElement('style');
        s.textContent = '*{-webkit-touch-callout:none;-webkit-user-select:none;user-select:none;-webkit-tap-highlight-color:transparent} input,textarea{-webkit-user-select:text;user-select:text}';
        document.head.appendChild(s);
      });
    })();
    """
}
