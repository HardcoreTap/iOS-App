import SwiftUI

struct LeaderboardScreen: View {

    @Environment(GameCenterService.self) private var gameCenter
    @Environment(PlayerProfile.self) private var profile

    @State private var mode: GameMode = .normal
    @State private var signInPrompt: SignInPrompt?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Mode", selection: $mode) {
                        ForEach(GameMode.allCases) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                }

                personalSection

                if gameCenter.isAuthenticated {
                    globalSection
                } else {
                    unavailableSection
                }
            }
            .scrollContentBackground(.hidden)
            .background { PulseBackground(beat: 1, progress: 0.7, isActive: false) }
            .navigationTitle("Leaderboard")
            .task(id: mode) { await gameCenter.loadTopScores(mode: mode) }
            .refreshable { await gameCenter.loadTopScores(mode: mode) }
            .sheet(item: $signInPrompt, onDismiss: gameCenter.dismissSignIn) { prompt in
                PresentedController(controller: prompt.controller)
                    .ignoresSafeArea()
            }
        }
    }

    private var personalSection: some View {
        Section("Your best") {
            HStack {
                Text(profile.nickname.isEmpty ? String(localized: "You") : profile.nickname)
                    .font(.headline)
                Spacer()
                Text("\(profile.best(for: mode))")
                    .font(.title3.weight(.bold))
                    .monospacedDigit()
            }
            .listRowBackground(Color.lipstick.opacity(0.25))
        }
    }

    @ViewBuilder
    private var globalSection: some View {
        Section("Game Center") {
            if gameCenter.isLoading {
                ProgressView().frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
            } else if gameCenter.entries.isEmpty {
                Text("No scores posted yet. Be the first.")
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(gameCenter.entries) { entry in
                    row(for: entry)
                }
            }
        }
    }

    private func row(for entry: GameCenterService.Entry) -> some View {
        HStack(spacing: 14) {
            if entry.rank <= 3 {
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellowishGreen)
                    .frame(width: 28)
            } else {
                Text("\(entry.rank)")
                    .font(.footnote.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .frame(width: 28)
            }
            Text(entry.name)
            Spacer()
            Text("\(entry.score)")
                .font(.body.weight(.semibold))
                .monospacedDigit()
        }
        .listRowBackground(entry.isLocalPlayer ? Color.lipstick.opacity(0.25) : Color.clear)
    }

    @ViewBuilder
    private var unavailableSection: some View {
        Section("Game Center") {
            switch gameCenter.status {
            case .authenticating, .unknown:
                ProgressView().frame(maxWidth: .infinity)
            case .unavailable(let reason):
                ContentUnavailableView {
                    Label("Global scores unavailable", systemImage: "trophy.slash")
                } description: {
                    Text(reason)
                } actions: {
                    // Game Center hands its sign-in flow over during launch; showing it
                    // here means the player opts in instead of being ambushed by a modal.
                    if let controller = gameCenter.signInController {
                        Button("Sign in to Game Center") {
                            signInPrompt = SignInPrompt(controller: controller)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            case .authenticated:
                EmptyView()
            }
        }
        .listRowBackground(Color.clear)
    }
}

#Preview {
    LeaderboardScreen()
        .environment(GameCenterService())
        .environment(PlayerProfile())
        .preferredColorScheme(.dark)
}
