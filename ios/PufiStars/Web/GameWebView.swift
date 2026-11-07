import SwiftUI
import WebKit

/// Afișează jocul HTML din pachetul aplicației (merge offline).
struct GameWebView: UIViewRepresentable {
    let bridge: Bridge

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let controller = WKUserContentController()
        controller.add(WeakScriptHandler(bridge), name: "native")
        controller.addUserScript(WKUserScript(source: Bridge.jsShim,
                                              injectionTime: .atDocumentStart,
                                              forMainFrameOnly: true))
        config.userContentController = controller

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.74, green: 0.90, blue: 1.0, alpha: 1)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsLinkPreview = false
        webView.navigationDelegate = context.coordinator
        #if DEBUG
        if #available(iOS 16.4, *) { webView.isInspectable = true }
        #endif

        bridge.webView = webView

        if let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "WebContent") {
            // Blochează și resursele externe (de exemplu fonturi), nu doar navigarea.
            let rules = #"[{"trigger":{"url-filter":"^https?://"},"action":{"type":"block"}}]"#
            WKContentRuleListStore.default().compileContentRuleList(
                forIdentifier: "PufiOffline", encodedContentRuleList: rules
            ) { rules, error in
                if let rules, error == nil {
                    controller.add(rules)
                } else {
                    NSLog("Pufi offline content rule failed: %@", error?.localizedDescription ?? "No rule list")
                }
                webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            }
        } else {
            webView.loadHTMLString("<h1 style='font-family:sans-serif'>Run ios/sync_web.sh, then build again.</h1>", baseURL: nil)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    /// Copiii nu pot ieși din aplicație pe linkuri externe (cerință pentru categoria Kids).
    final class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
            let scheme = navigationAction.request.url?.scheme ?? ""
            decisionHandler(scheme == "file" || scheme == "about" || scheme == "data" || scheme == "blob" ? .allow : .cancel)
        }
    }
}

/// Evită ciclul de memorie dintre WKUserContentController și Bridge.
final class WeakScriptHandler: NSObject, WKScriptMessageHandler {
    weak var target: WKScriptMessageHandler?
    init(_ target: WKScriptMessageHandler) { self.target = target }
    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        target?.userContentController(controller, didReceive: message)
    }
}
