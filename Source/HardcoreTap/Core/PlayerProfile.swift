import Foundation
import Observation

/// Nickname and personal bests, persisted in `UserDefaults`.
///
/// Reads the key names the shipped 1.x app used so an existing install keeps its
/// record instead of starting from zero after the update.
@MainActor
@Observable
final class PlayerProfile {

    private enum Key {
        static let nickname = "userNAME"
        static func best(_ mode: GameMode) -> String { "highscore_\(mode.rawValue)" }
    }

    private let defaults: UserDefaults

    var nickname: String {
        didSet { defaults.set(nickname, forKey: Key.nickname) }
    }

    private(set) var bestScores: [GameMode: Int]

    var hasNickname: Bool { !nickname.trimmingCharacters(in: .whitespaces).isEmpty }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.nickname = defaults.string(forKey: Key.nickname) ?? ""
        self.bestScores = Dictionary(
            uniqueKeysWithValues: GameMode.allCases.map { ($0, defaults.integer(forKey: Key.best($0))) }
        )
    }

    func best(for mode: GameMode) -> Int { bestScores[mode] ?? 0 }

    /// Stores `score` if it beats the current record. Returns whether it did.
    @discardableResult
    func record(score: Int, mode: GameMode) -> Bool {
        guard score > best(for: mode) else { return false }
        bestScores[mode] = score
        defaults.set(score, forKey: Key.best(mode))
        return true
    }

    /// Wipes nickname and records — the "log out" the old settings screen offered.
    func reset() {
        nickname = ""
        for mode in GameMode.allCases {
            bestScores[mode] = 0
            defaults.removeObject(forKey: Key.best(mode))
        }
    }
}
