import SwiftUI

@main
struct PufiStarsApp: App {
    init() {
        PurchaseService.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @StateObject private var bridge = Bridge()

    var body: some View {
        GameWebView(bridge: bridge)
            .ignoresSafeArea()
            .background(Color(red: 0.74, green: 0.90, blue: 1.0))
            .statusBarHidden(true)
            .persistentSystemOverlays(.hidden)
            .sheet(item: $bridge.gateRequest) { request in
                ParentalGateView(language: request.language) { passed in
                    bridge.finishGate(request, passed: passed)
                }
                .interactiveDismissDisabled(true)
            }
    }
}
