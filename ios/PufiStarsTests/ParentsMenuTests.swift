import XCTest
import SwiftUI
import WebKit
@testable import PufiStars

@MainActor
final class ParentsMenuTests: XCTestCase {
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
        try await waitFor("document.readyState === 'complete' && !!window.__parentsText")
    }

    override func tearDown() async throws {
        _ = try? await js("document.querySelector('.pa-close')?.click(); window.__setLang('ro'); true")
        web.stopLoading()
        window.isHidden = true
        window = nil
        web = nil
        bridge = nil
    }

    private func js(_ code: String) async throws -> Any? { try await web.evaluateJavaScript(code) }

    private func waitFor(_ condition: String) async throws {
        for _ in 0..<150 {
            if try await js(condition) as? Bool == true { return }
            try await Task.sleep(nanoseconds: 100_000_000)
        }
        XCTFail("Timed out: \(condition)")
    }

    private func open(_ language: String = "en") async throws {
        _ = try await js("window.__setLang('\(language)'); window.__hmOpen('par'); true")
        for _ in 0..<100 {
            if let request = bridge.gateRequest { bridge.finishGate(request, passed: true); break }
            try await Task.sleep(nanoseconds: 50_000_000)
        }
        try await waitFor("!!document.querySelector('.pa-info') && !!document.querySelector('.pa-restore')")
    }

    func testTwelveLanguagesHaveCompactAccessibleCardsAndRestoreVoiceOnClose() async throws {
        for language in ["ro", "en", "de", "fr", "it", "es", "pt", "nl", "pl", "hu", "uk", "ru"] {
            try await open(language)
            let geometry = try await js("""
            (()=>{const p=document.querySelector('.pa-panel'), b=document.querySelector('.pa-body'), c=document.querySelector('.pa-close');
            const r=p.getBoundingClientRect(), cr=c.getBoundingClientRect(); return {
              horizontal:p.scrollWidth<=p.clientWidth+1 && b.scrollWidth<=b.clientWidth+1,
              viewport:r.top>=0 && r.bottom<=innerHeight+1 && r.left>=0 && r.right<=innerWidth+1,
              closeVisible:cr.top>=0 && cr.bottom<=innerHeight && cr.width>=44 && cr.height>=44,
              sections:p.querySelectorAll('details').length, expanded:p.querySelectorAll('details[open]').length,
              firstCard:b.firstElementChild.classList.contains('pa-purchase'),
              slots:p.querySelector('.pa-recordings select').options.length,
              voices:document.querySelectorAll('#voice').length,
              modal:p.getAttribute('aria-modal')==='true', homeInert:document.querySelector('#hm-root').inert,
              language:window.__parentsText().sound
            };})()
            """) as? [String: Any]
            let result = try XCTUnwrap(geometry)
            for key in ["horizontal", "viewport", "closeVisible", "firstCard", "modal", "homeInert"] {
                XCTAssertEqual(result[key] as? Bool, true, "\(language): \(key)")
            }
            XCTAssertEqual(result["sections"] as? Int, 3, language)
            XCTAssertEqual(result["expanded"] as? Int, 0, language)
            XCTAssertEqual(result["slots"] as? Int, 5, language)
            XCTAssertEqual(result["voices"] as? Int, 1, language)
            XCTAssertFalse((result["language"] as? String ?? "").isEmpty)
            _ = try await js("document.querySelector('.pa-close').click(); true")
            let restored = try await js("!document.querySelector('.pa-overlay') && !document.querySelector('#hm-root').inert && document.querySelectorAll('#voice').length===1 && !document.querySelector('#voice').closest('.pa-panel')") as? Bool
            XCTAssertEqual(restored, true, language)
        }
    }

    func testSelectedPraiseSlotAndImmediateStopWhenClosing() async throws {
        _ = try await js("""
        window.__recCalls=[]; const realCall=window.native.call.bind(window.native);
        window.native.call=(cmd,args)=>{if(cmd.startsWith('rec.')){
          window.__recCalls.push({cmd,args}); return Promise.resolve(cmd==='rec.list'?['praise2']:true);
        }return realCall(cmd,args);}; true
        """)
        try await open("ro")
        _ = try await js("""
        document.querySelector('.pa-recordings').open=true;
        const select=document.querySelector('.pa-recordings select'); select.value='2'; select.onchange();
        document.querySelector('.pa-record').click(); true
        """)
        try await waitFor("document.querySelector('.pa-record').classList.contains('on')")
        let selected = try await js("window.__recCalls.some(c=>c.cmd==='rec.start' && c.args.key==='praise2') && document.querySelector('.pa-recordings select').disabled") as? Bool
        XCTAssertEqual(selected, true)
        _ = try await js("document.querySelector('.pa-close').click(); true")
        try await waitFor("window.__recCalls.filter(c=>c.cmd==='rec.stop').length===1")
    }

    func testExpandedSectionsShowScrollCueAndKeepCloseVisible() async throws {
        try await open("de")
        _ = try await js("document.querySelectorAll('.pa-section').forEach(d=>d.open=true); true")
        try await waitFor("!document.querySelector('.pa-scroll-track').hidden && document.querySelector('.pa-scroll-hint').style.visibility==='visible'")
        _ = try await js("(()=>{window.__headerTop=document.querySelector('.pa-header').getBoundingClientRect().top; const scroller=document.querySelector('.pa-body'); scroller.scrollTop=scroller.scrollHeight; scroller.dispatchEvent(new Event('scroll'));})(); true")
        try await waitFor("document.querySelector('.pa-scroll-hint').style.visibility==='hidden'")
        let fixed = try await js("Math.abs(document.querySelector('.pa-header').getBoundingClientRect().top-window.__headerTop)<1 && document.querySelector('.pa-close').getBoundingClientRect().top>=0") as? Bool
        XCTAssertEqual(fixed, true)
    }

    func testBirthdayReadsLegacyValueAndOnlyEditsMonthAndDay() async throws {
        let old = try await js("localStorage.getItem('tm_bday')")
        let encoded = String(data: try JSONSerialization.data(withJSONObject: [old ?? NSNull()]), encoding: .utf8)!
        defer { web.evaluateJavaScript("(()=>{const oldBirthday=\(encoded)[0]; if(oldBirthday===null) localStorage.removeItem('tm_bday'); else localStorage.setItem('tm_bday',oldBirthday);})();", completionHandler: nil) }
        _ = try await js("localStorage.setItem('tm_bday','2019-07-14'); true")
        try await open("ro")
        let legacy = try await js("document.querySelector('.pa-birthday-month').value==='7' && document.querySelector('.pa-birthday-day').value==='14' && !document.querySelector('.pa-personal input') && localStorage.getItem('tm_bday')==='2019-07-14'") as? Bool
        XCTAssertEqual(legacy, true)
        _ = try await js("(()=>{const field=document.querySelector('.pa-birthday-day'); field.value='15'; field.onchange();})(); true")
        let updated = try await js("localStorage.getItem('tm_bday')") as? String
        XCTAssertEqual(updated, "07-15")
        _ = try await js("document.querySelector('.pa-birthday-clear').click(); true")
        let cleared = try await js("localStorage.getItem('tm_bday')===null && !document.querySelector('.pa-birthday-month').value && !document.querySelector('.pa-birthday-day').value") as? Bool
        XCTAssertEqual(cleared, true)
    }

    func testOwnedCardRetainsExplicitRestoreAction() async throws {
        try await open()
        _ = try await js("document.querySelector('.pa-restore').click(); true")
        try await waitFor("document.querySelector('.pa-status').textContent===window.__parentsText().checked")
        let retained = try await js("document.querySelector('.pa-purchase').classList.contains('pa-owned') && !!document.querySelector('.pa-restore') && !document.querySelector('.pa-primary')") as? Bool
        XCTAssertEqual(retained, true)
    }
}
