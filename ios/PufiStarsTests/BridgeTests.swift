import XCTest
import SwiftUI
import WebKit
import AVFoundation
@testable import PufiStars

@MainActor
final class BridgeTests: XCTestCase {
    private var window: UIWindow!
    private var bridge: Bridge!
    private var web: WKWebView!

    override func setUp() async throws {
        bridge = Bridge()
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: GameWebView(bridge: bridge))
        window.makeKeyAndVisible()
        window.rootViewController?.view.layoutIfNeeded()
        web = bridge.webView
        XCTAssertNotNil(web)
        try await waitFor("document.readyState === 'complete' && !!window.__parentsGate")
    }

    override func tearDown() async throws {
        web.stopLoading()
        window.isHidden = true
        window = nil
        web = nil
        bridge = nil
    }

    private func js(_ source: String) async throws -> Any? {
        try await web.evaluateJavaScript(source)
    }

    private func call(_ command: String, args: String = "{}") async throws -> Any? {
        try await web.callAsyncJavaScript("return await native.call(command, args)",
            arguments: ["command": command, "args": try JSONSerialization.jsonObject(with: Data(args.utf8))],
            in: nil, contentWorld: .page)
    }

    private func waitFor(_ condition: String) async throws {
        for _ in 0..<200 {
            if try await js(condition) as? Bool == true { return }
            try await Task.sleep(nanoseconds: 100_000_000)
        }
        let diagnostic = try await js("JSON.stringify({charset:document.characterSet,title:document.title,native:typeof window.native,gate:typeof window.__parentsGate,body:document.body.innerText.slice(0,200)})")
        XCTFail("Timed out: \(condition); document: \(diagnostic ?? "unavailable")")
    }

    func testBundledGameLanguageVoiceAndDebugPurchases() async throws {
        XCTAssertTrue(web.url?.isFileURL == true)
        let cards = try await js("document.querySelectorAll('.hm-card').length") as? Int
        XCTAssertEqual(cards, 9)
        defer { web.evaluateJavaScript("window.__setLang('ro')", completionHandler: nil) }
        _ = try await js("window.__setLang('de'); true")
        let language = try await js("lang") as? String
        XCTAssertEqual(language, "de")
        let voice = try await call("voiceInfo", args: #"{"lang":"de"}"#) as? [String: Any]
        XCTAssertTrue((voice?["language"] as? String)?.hasPrefix("de") == true)
        XCTAssertFalse((voice?["name"] as? String ?? "").isEmpty)
        for command in ["iap.status", "iap.buy", "iap.restore"] {
            let premium = try await call(command) as? Bool
            XCTAssertEqual(premium, true, command)
        }
        let price = try await call("iap.price") as? String
        XCTAssertEqual(price, "")
    }

    func testStoreAndGateRoundTrip() async throws {
        let old = ProgressStore().load()
        defer { UserDefaults.standard.set(old, forKey: "pufi.localStorage.snapshot") }
        let saved = try await call("store.set", args: #"{"snapshot":"{\"test\":\"progress\"}"}"#) as? Bool
        XCTAssertEqual(saved, true)
        let snapshot = try await call("store.get") as? String
        XCTAssertEqual(snapshot, #"{"test":"progress"}"#)
        XCTAssertEqual(ProgressStore().load(), snapshot)
        _ = try await js("window.gateResult = null; native.call('gate',{lang:'de'}).then(v=>window.gateResult=v); true")
        try await Task.sleep(nanoseconds: 100_000_000)
        let request = try XCTUnwrap(bridge.gateRequest)
        XCTAssertEqual(request.language, "de")
        bridge.finishGate(request, passed: false)
        try await waitFor("window.gateResult === false")
        XCTAssertNil(bridge.gateRequest)
    }

    func testExternalNavigationBlockedAndMissingRecordingResolves() async throws {
        let original = web.url
        _ = try await js("location.href = 'https://example.com'")
        try await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertEqual(web.url, original)
        let result = try await call("rec.play", args: #"{"key":"nonexistent-test-recording"}"#) as? Bool
        XCTAssertEqual(result, true)
        let recordings = try await call("rec.list") as? [String]
        XCTAssertNotNil(recordings)
    }

    func testASRPermissionQueryDoesNotRequestAuthorization() async throws {
        let before = RecognitionService.permissions()
        let response = try await call("asr.perm") as? [String: String]
        XCTAssertEqual(response, before)
        XCTAssertEqual(RecognitionService.permissions(), before)
        print("PUFI_ASR_PERMISSIONS: \(response ?? [:])")
        for language in ["ro", "en"] {
            let availability = try await call("asr.available", args: "{\"lang\":\"\(language)\"}")
            print("PUFI_ASR_AVAILABLE \(language): \(availability ?? "nil")")
        }
    }

    func testASRDenialHasReasonWhenPermissionIsAlreadyDenied() async throws {
        let state = RecognitionService.permissions()
        guard state["speech"] == "denied" || state["speech"] == "restricted" || state["mic"] == "denied" else {
            throw XCTSkip("Requires an actual denied permission; never prompts during the unit suite")
        }
        let response = try await call("asr.start", args: #"{"lang":"ro","words":[]}"#) as? [String: Any]
        XCTAssertEqual(response?["ok"] as? Bool, false)
        XCTAssertEqual(response?["reason"] as? String,
                       RecognitionService.permissionFailure(speech: state["speech"]!, mic: state["mic"]!)?.reason)
        print("PUFI_ASR_DENIAL: \(response ?? [:])")
    }

    func testASRStartsAndTTSStopsRecordingOnAuthorizedDevice() async throws {
        #if targetEnvironment(simulator)
        throw XCTSkip("Requires a physical microphone")
        #else
        guard RecognitionService.permissions() == ["speech": "authorized", "mic": "granted"] else {
            throw XCTSkip("Authorize both permissions before this device test")
        }
        for language in ["ro", "en"] {
            _ = try await js("window.asrEnds=[]; window.asrTexts=[]; native.on('asr.end',e=>asrEnds.push(e)); native.on('asr.partial',e=>asrTexts.push(e))")
            let result = try await call("asr.start", args: "{\"lang\":\"\(language)\",\"words\":[]}")
            print("PUFI_ASR_START \(language): \(result ?? "nil")")
            XCTAssertEqual(result as? Bool, true)
            try await Task.sleep(nanoseconds: 3_000_000_000)
            let diagnostic = try await js("JSON.stringify({ends:asrEnds,partialCount:asrTexts.length})")
            print("PUFI_ASR_OBSERVATION \(language): \(diagnostic ?? "nil")")
            _ = try await call("speak", args: "{\"lang\":\"\(language)\",\"text\":\"Pufi\"}")
            XCTAssertEqual(AVAudioSession.sharedInstance().category, .playback)
            _ = try await call("asr.stop")
        }
        #endif
    }

    func testNativeSpeechEmitsWordEvents() async throws {
        _ = try await js("window.testWords=[]; native.on('speak.word',e=>window.testWords.push(e))")
        let result = try await call("speak", args: #"{"text":"Hello Pufi","lang":"en","words":true}"#) as? Bool
        XCTAssertEqual(result, true)
        let count = try await js("window.testWords.length") as? Int ?? 0
        XCTAssertGreaterThan(count, 0)
    }
}
