import SwiftUI
import UIKit

/// Decides between the nickname prompt and the tab bar.
struct RootView: View {

    @Environment(PlayerProfile.self) private var profile
    @Environment(GameCenterService.self) private var gameCenter
    @Environment(ToastCenter.self) private var toasts

    var body: some View {
        Group {
            if profile.hasNickname {
                MainTabView()
                    .transition(.opacity)
            } else {
                WelcomeScreen()
                    .transition(.opacity)
            }
        }
        .animation(.smooth, value: profile.hasNickname)
        .toastLayer(toasts)
        .task { gameCenter.authenticate() }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Game", systemImage: "metronome") {
                GameScreen()
            }
            Tab("Leaderboard", systemImage: "trophy") {
                LeaderboardScreen()
            }
            Tab("Rules", systemImage: "list.number") {
                RulesScreen()
            }
            Tab("About", systemImage: "info.circle") {
                AboutScreen()
            }
        }
    }
}

/// Wrapper so `sheet(item:)` has something `Identifiable` to key on — conforming
/// `UIViewController` itself would drag main-actor isolation into the conformance.
struct SignInPrompt: Identifiable {
    let id = UUID()
    let controller: UIViewController
}

/// Puts a UIKit controller on screen without dragging a coordinator into the app.
/// This is the only UIKit left: `GKLocalPlayer` hands its sign-in flow back as one.
struct PresentedController: UIViewControllerRepresentable {
    let controller: UIViewController

    func makeUIViewController(context: Context) -> UIViewController { controller }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
