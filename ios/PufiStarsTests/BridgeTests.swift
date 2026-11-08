import XCTest
import SwiftUI
import WebKit
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

    func testNativeSpeechEmitsWordEvents() async throws {
        _ = try await js("window.testWords=[]; native.on('speak.word',e=>window.testWords.push(e))")
        let result = try await call("speak", args: #"{"text":"Hello Pufi","lang":"en","words":true}"#) as? Bool
        XCTAssertEqual(result, true)
        let count = try await js("window.testWords.length") as? Int ?? 0
        XCTAssertGreaterThan(count, 0)
    }

    func testRomanianIPAPlaybackAndOriginalWordRanges() async throws {
        let text = "La ora două."
        let attributed = try XCTUnwrap(SpeechService.withPronunciation(text, lang: "ro"))
        XCTAssertEqual(attributed.string, text)
        XCTAssertNil(SpeechService.withPronunciation("O oră, o orășel.", lang: "ro"))
        XCTAssertNil(SpeechService.withPronunciation(text, lang: "en"))

        let playback = try await call("speak", args: #"{"text":"La ora două.","lang":"ro","words":false}"#) as? Bool
        XCTAssertEqual(playback, true)

        _ = try await js("window.testIPA=[]; native.on('speak.word',e=>window.testIPA.push(e)); true")
        let result = try await call("speak", args: #"{"text":"La ora două.","lang":"ro","words":true}"#) as? Bool
        XCTAssertEqual(result, true)
        let events = try await js("window.testIPA") as? [[String: Int]] ?? []
        let original = text as NSString
        let words = try events.map { event -> String in
            let location = try XCTUnwrap(event["loc"])
            let length = try XCTUnwrap(event["len"])
            guard location >= 0, length > 0, location <= original.length,
                  length <= original.length - location else {
                XCTFail("Invalid speech range: \(event)")
                return ""
            }
            return original.substring(with: NSRange(location: location, length: length))
                .trimmingCharacters(in: .punctuationCharacters)
        }
        XCTAssertEqual(words, ["La", "ora", "două"])
    }

    func testPufiGiftAndEarnedTicket() async throws {
        let result = try await js("""
        (() => {
          const keys = ['pq_gift', 'pq_earn', 'pq_paid'];
          const old = keys.map(k => localStorage.getItem(k));
          try {
            keys.forEach(k => localStorage.removeItem(k));
            window.openPufi();
            const gift = document.querySelector('#pq-earn.ok')?.textContent.includes('🎟️');
            document.querySelector('[data-lk="pq:0"]').click();
            const started = window.__pq.state !== 'map' && localStorage.getItem('pq_gift') === '1';
            // Finishing a level clears pq_paid. Model that boundary without playing the platformer.
            localStorage.removeItem('pq_paid');
            window.openPufi();
            document.querySelector('[data-lk="pq:0"]').click();
            const blocked = window.__pq.state === 'map';
            localStorage.setItem('pq_earn', '30');
            window.openPufi();
            document.querySelector('[data-lk="pq:0"]').click();
            return {gift, started, blocked, paid: localStorage.getItem('pq_paid') === '1',
                    remaining: Number(localStorage.getItem('pq_earn'))};
          } finally {
            keys.forEach((k,i) => old[i] === null ? localStorage.removeItem(k) : localStorage.setItem(k,old[i]));
          }
        })()
        """) as? [String: Any]
        let state = try XCTUnwrap(result)
        for key in ["gift", "started", "blocked", "paid"] {
            XCTAssertEqual(state[key] as? Bool, true, key)
        }
        XCTAssertEqual(state["remaining"] as? Int, 15)
    }

    func testRoboGridHelpAndCircuitWireRemoval() async throws {
        let result = try await js("""
        (() => {
          const old = localStorage.getItem('grid_prog');
          const outcomes = [];
          const click = selector => document.querySelector(selector).click();
          try {
            localStorage.setItem('grid_prog', '{"0":1,"1":1,"2":1}');
            window.openRobo();
            click('[data-lk="rb:grid"]');
            for (const index of [0,3]) {
              document.querySelectorAll('.gr-card')[index].click();
              const story = document.querySelector('.gr-bub').textContent.startsWith('📖');
              click('.gr-next');
              click('.gr-help');
              const explains = document.querySelector('.gr-tip').textContent.startsWith('❓');
              click('.gr-help');
              const points = document.querySelector('.gr-tip').textContent.startsWith('👆');
              outcomes.push(story && explains && points);
              click('#gr-back');
            }
            click('#gr-back');
            click('[data-lk="rb:circ"]');
            click('.rb-grid .rb-card');
            const from = document.querySelector('.rb-term[data-t="bat.b"]');
            const to = document.querySelector('.rb-term[data-t="L1.b"]');
            const r = to.getBoundingClientRect();
            const svg = from.ownerSVGElement;
            from.dispatchEvent(new PointerEvent('pointerdown', {bubbles:true}));
            svg.dispatchEvent(new PointerEvent('pointerup', {clientX:r.x+r.width/2,clientY:r.y+r.height/2}));
            const wire = document.querySelector('.rb-wire');
            wire?.dispatchEvent(new MouseEvent('click',{bubbles:true}));
            const cut = document.querySelector('#rb-cut');
            const selected = !!cut && !!document.querySelector('.rb-wire');
            cut?.dispatchEvent(new MouseEvent('click',{bubbles:true}));
            return {outcomes, selected, removed: !document.querySelector('.rb-wire')};
          } finally {
            if (old === null) localStorage.removeItem('grid_prog'); else localStorage.setItem('grid_prog',old);
          }
        })()
        """) as? [String: Any]
        let state = try XCTUnwrap(result)
        XCTAssertEqual(state["outcomes"] as? [Bool], [true, true])
        XCTAssertEqual(state["selected"] as? Bool, true)
        XCTAssertEqual(state["removed"] as? Bool, true)
    }

}
