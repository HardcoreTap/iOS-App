import SwiftUI

/// Nickname prompt. The 2017 version wrote straight into `UserDefaults` from an
/// `@IBAction` and pushed a segue; the storage key is the same so an existing player
/// never sees this screen again after updating.
struct WelcomeScreen: View {

    @Environment(PlayerProfile.self) private var profile
    @State private var draft = ""
    @FocusState private var isFocused: Bool

    private var trimmed: String {
        draft.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        ZStack {
            PulseBackground(beat: 0, progress: 0.5, isActive: false)

            VStack(spacing: 28) {
                Image(.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 160)

                VStack(spacing: 8) {
                    Text("Welcome!")
                        .font(.largeTitle.weight(.bold))
                    Text("Pick a nickname to start chasing the beat.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                TextField("Nickname", text: $draft)
                    .textFieldStyle(.plain)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.go)
                    .focused($isFocused)
                    .onSubmit(commit)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .glassEffect(.regular, in: .capsule)

                Button(action: commit) {
                    Text("Start game")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .tint(.lipstick)
                .disabled(trimmed.isEmpty)
            }
            .padding(.horizontal, 32)
        }
        .onAppear { isFocused = true }
    }

    private func commit() {
        guard !trimmed.isEmpty else { return }
        profile.nickname = trimmed
    }
}

#Preview {
    WelcomeScreen()
        .environment(PlayerProfile())
        .preferredColorScheme(.dark)
}
