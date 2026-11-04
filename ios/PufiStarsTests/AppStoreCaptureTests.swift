import XCTest
import WebKit

/// Drives the existing, visible app for genuine simctl screen recordings.
/// Opt-in only: the host must create Documents/AppStoreCapture/enabled first.
@MainActor
final class AppStoreCaptureTests: XCTestCase {
    func testCaptureSession() async throws {
        #if !targetEnvironment(simulator)
        throw XCTSkip("App Store capture runs only in Simulator")
        #else
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("AppStoreCapture")
        guard FileManager.default.fileExists(atPath: folder.appendingPathComponent("enabled").path) else {
            throw XCTSkip("App Store capture is an opt-in simulator session")
        }
        defer { try? FileManager.default.removeItem(at: folder) }
        executionTimeAllowance = 7200
        func findWeb(_ view: UIView) -> WKWebView? {
            if let web = view as? WKWebView { return web }
            return view.subviews.lazy.compactMap { findWeb($0) }.first
        }
        var web: WKWebView?
        for _ in 0..<300 {
            web = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows).compactMap { findWeb($0) }.first
            if let web, (try? await web.evaluateJavaScript("document.readyState === 'complete' && !!window.__hmOpen")) as? Bool == true { break }
            try await Task.sleep(nanoseconds: 100_000_000)
        }
        let visibleWeb = try XCTUnwrap(web)
        try Data("ready".utf8).write(to: folder.appendingPathComponent("ready"), options: .atomic)
        let commandURL = folder.appendingPathComponent("command.json")
        let responseURL = folder.appendingPathComponent("response.json")
        var previous = ""
        while true {
            if let data = try? Data(contentsOf: commandURL),
               let command = try? JSONSerialization.jsonObject(with: data) as? [String: String],
               let id = command["id"], id != previous {
                previous = id
                var response: [String: Any] = ["id": id]
                do {
                    if command["action"] == "stop" { break }
                    if command["action"] == "landscape" || command["action"] == "portrait" {
                        let scene = try XCTUnwrap(visibleWeb.window?.windowScene)
                        scene.requestGeometryUpdate(.iOS(interfaceOrientations:
                            command["action"] == "portrait" ? .portrait : .landscapeRight))
                        response["value"] = "orientation requested"
                    } else if command["action"] == "reload" {
                        visibleWeb.reload()
                        response["value"] = "reloading"
                    } else {
                        let value = try await visibleWeb.evaluateJavaScript(command["js"] ?? "null")
                        response["value"] = value ?? NSNull()
                    }
                } catch { response["error"] = error.localizedDescription }
                let result = try JSONSerialization.data(withJSONObject: response, options: [.sortedKeys, .fragmentsAllowed])
                try result.write(to: responseURL, options: .atomic)
            }
            try await Task.sleep(nanoseconds: 40_000_000)
        }
        #endif
    }
}
