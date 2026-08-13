import SwiftUI

struct SettingsScreen: View {

    @Environment(Metronome.self) private var metronome
    @Environment(PlayerProfile.self) private var profile
    @Environment(\.dismiss) private var dismiss

    @State private var showsResetConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Background beat", isOn: Bindable(metronome).isEnabled)
                } footer: {
                    Text("A 60 BPM loop that plays during a round. It mixes with your music instead of interrupting it.")
                }

                Section("Player") {
                    LabeledContent("Nickname", value: profile.nickname)
                    ForEach(GameMode.allCases) { mode in
                        LabeledContent(String(localized: mode.title), value: "\(profile.best(for: mode))")
                    }
                }

                Section {
                    Button("Reset progress", role: .destructive) {
                        showsResetConfirmation = true
                    }
                } footer: {
                    Text("Clears your nickname and local records. Game Center scores are not affected.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .confirmationDialog(
                "Reset progress?",
                isPresented: $showsResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset", role: .destructive) {
                    profile.reset()
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

#Preview {
    SettingsScreen()
        .environment(Metronome())
        .environment(PlayerProfile())
}
