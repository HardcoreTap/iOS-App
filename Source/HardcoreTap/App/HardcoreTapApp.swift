import SwiftUI

@main
struct HardcoreTapApp: App {

    @State private var profile = PlayerProfile()
    @State private var gameCenter = GameCenterService()
    @State private var metronome = Metronome()
    @State private var toasts = ToastCenter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(profile)
                .environment(gameCenter)
                .environment(metronome)
                .environment(toasts)
                .preferredColorScheme(.dark)
        }
    }
}
