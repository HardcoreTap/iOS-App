import Foundation

/// The two difficulty presets the original game exposed as a "hardcore" switch.
///
/// A round is a metronome: the player must tap once per second. `tolerance(forScore:)`
/// is the window around each beat that still counts as a hit, and it shrinks as the
/// round goes on.
enum GameMode: String, CaseIterable, Identifiable, Sendable {
    case normal
    case hardcore

    var id: String { rawValue }

    /// Window around the very first beat.
    var startingTolerance: TimeInterval {
        switch self {
        case .normal: 0.10
        case .hardcore: 0.01
        }
    }

    /// The window never shrinks past this.
    var minimumTolerance: TimeInterval {
        switch self {
        case .normal: 0.05
        case .hardcore: 0.01
        }
    }

    /// How much the window narrows after every successful beat.
    var toleranceStep: TimeInterval { 0.01 }

    /// Window the beat after `score` hits is judged against.
    func tolerance(forScore score: Int) -> TimeInterval {
        let shrunk = startingTolerance - toleranceStep * TimeInterval(score)
        return max(minimumTolerance, shrunk)
    }

    /// Game Center leaderboard this mode reports to.
    ///
    /// These IDs must exist in App Store Connect; until they do, submissions fail
    /// silently and the leaderboard screen falls back to the locally stored best.
    var leaderboardID: String {
        switch self {
        case .normal: "hardcoretap.leaderboard.normal"
        case .hardcore: "hardcoretap.leaderboard.hardcore"
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .normal: "Normal"
        case .hardcore: "Hardcore"
        }
    }

    var subtitle: LocalizedStringResource {
        switch self {
        case .normal: "Tolerance narrows from 0.10 s down to 0.05 s."
        case .hardcore: "A flat 0.01 s window. No mercy."
        }
    }
}
