import SwiftUI

struct AboutScreen: View {

    private static let repository = URL(string: "https://github.com/HardcoreTap/HardcoreTap-iOS-App")!
    private static let appStore = URL(string: "https://apps.apple.com/app/hardcoretap/id1319571993")!

    private let authors = ["Dunaev Sergey", "Bystritskiy Bogdan", "Anpleenko Pavel"]

    var body: some View {
        NavigationStack {
            List {
                Section("About the game") {
                    Text("Catch the rhythm. HardcoreTap trains your attention, patience and sense of timing. Tap the screen once a second, accurate to hundredths. The higher you climb, the stricter it gets. Think that's easy? Try it.")
                        .font(.callout)
                        .listRowBackground(Color.clear)
                }

                Section("Spread the word") {
                    Link(destination: Self.appStore) {
                        Label("Rate on the App Store", systemImage: "star")
                    }
                    Link(destination: Self.repository) {
                        Label("Source on GitHub", systemImage: "chevron.left.forwardslash.chevron.right")
                    }
                }
                .listRowBackground(Color.clear)

                Section("Built at the Swiftbook hackathon") {
                    ForEach(authors, id: \.self) { author in
                        Label(author, systemImage: "person")
                    }
                }
                .listRowBackground(Color.clear)

                Section {
                    LabeledContent("Version", value: Self.version)
                        .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .background { PulseBackground(beat: 4, progress: 0.7, isActive: false) }
            .navigationTitle("About game")
        }
    }

    private static var version: String {
        let info = Bundle.main.infoDictionary
        let short = info?["CFBundleShortVersionString"] as? String ?? "—"
        let build = info?["CFBundleVersion"] as? String ?? "—"
        return "\(short) (\(build))"
    }
}

#Preview {
    AboutScreen().preferredColorScheme(.dark)
}
