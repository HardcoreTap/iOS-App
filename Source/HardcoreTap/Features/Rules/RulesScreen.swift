import SwiftUI

struct RulesScreen: View {

    private struct Rule: Identifiable {
        let id: Int
        let image: ImageResource
        let text: LocalizedStringKey
    }

    private let rules: [Rule] = [
        Rule(
            id: 1,
            image: .rule1,
            text: "Tap the screen exactly once a second. A perfect hit is 00 milliseconds off."
        ),
        Rule(
            id: 2,
            image: .rule2,
            text: "The longer you last, the tighter it gets — the tolerance shrinks towards zero."
        ),
        Rule(
            id: 3,
            image: .rule3,
            text: "Catch the rhythm better than anyone and take the top of the leaderboard."
        ),
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(rules) { rule in
                    HStack(alignment: .center, spacing: 16) {
                        Image(rule.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                        Text(rule.text)
                            .font(.callout)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
                }

                Section {
                    ForEach(GameMode.allCases) { mode in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(mode.title).font(.headline)
                            Text(mode.subtitle)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(Color.clear)
                    }
                } header: {
                    Text("Modes")
                }
            }
            .scrollContentBackground(.hidden)
            .background { PulseBackground(beat: 3, progress: 0.7, isActive: false) }
            .navigationTitle("Rules")
        }
    }
}

#Preview {
    RulesScreen().preferredColorScheme(.dark)
}
