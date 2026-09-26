import GameKit
import Observation
import UIKit

/// Game Center access, wrapped so the rest of the app never touches `GKLocalPlayer`.
///
/// The 2017 code used `GKScore.report`, deprecated years ago. This uses the modern
/// `GKLeaderboard` async API and, crucially, treats an unavailable Game Center as a
/// normal state rather than an error: the leaderboard screen still shows the player's
/// local records.
@MainActor
@Observable
final class GameCenterService {

    struct Entry: Identifiable, Sendable {
        let id: String
        let rank: Int
        let name: String
        let score: Int
        let isLocalPlayer: Bool
    }

    enum Status: Equatable {
        case unknown
        case authenticating
        case authenticated
        /// Signed out, or the leaderboards are not configured in App Store Connect yet.
        case unavailable(String)
    }

    private(set) var status: Status = .unknown
    private(set) var entries: [Entry] = []
    private(set) var isLoading = false

    /// Set when Game Center wants to show its sign-in UI. Deliberately *not* presented
    /// automatically: the handler fires during launch, and throwing a modal over the
    /// game before the player has asked for anything is both jarring and — when Game
    /// Center is misconfigured — a blank sheet in front of the app. The leaderboard
    /// offers a sign-in button instead.
    private(set) var signInController: UIViewController?

    var isAuthenticated: Bool { status == .authenticated }

    /// Kicks off authentication. `GKLocalPlayer` only offers a handler-based API here.
    func authenticate() {
        guard status == .unknown else { return }
        status = .authenticating

        GKLocalPlayer.local.authenticateHandler = { [weak self] viewController, error in
            MainActor.assumeIsolated {
                guard let self else { return }
                if let viewController {
                    self.signInController = viewController
                    self.status = .unavailable(String(localized: "Game Center is not signed in."))
                } else if GKLocalPlayer.local.isAuthenticated {
                    self.signInController = nil
                    self.status = .authenticated
                } else {
                    self.status = .unavailable(
                        error?.localizedDescription ?? String(localized: "Game Center is not signed in.")
                    )
                }
            }
        }
    }

    func dismissSignIn() {
        signInController = nil
    }

    /// Reports a score. Failures are swallowed on purpose — a leaderboard that is not
    /// wired up in App Store Connect must not cost the player their game-over screen.
    func submit(score: Int, mode: GameMode) async {
        guard isAuthenticated else { return }
        try? await GKLeaderboard.submitScore(
            score,
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: [mode.leaderboardID]
        )
    }

    func loadTopScores(mode: GameMode) async {
        guard isAuthenticated else {
            entries = []
            return
        }
        isLoading = true
        defer { isLoading = false }

        do {
            let boards = try await GKLeaderboard.loadLeaderboards(IDs: [mode.leaderboardID])
            guard let board = boards.first else {
                status = .unavailable(String(localized: "This leaderboard is not configured yet."))
                entries = []
                return
            }
            let (_, loaded, _) = try await board.loadEntries(
                for: .global,
                timeScope: .allTime,
                range: NSRange(location: 1, length: 25)
            )
            entries = loaded.map { entry in
                Entry(
                    id: entry.player.gamePlayerID,
                    rank: entry.rank,
                    name: entry.player.displayName,
                    score: entry.score,
                    isLocalPlayer: entry.player == GKLocalPlayer.local
                )
            }
        } catch {
            status = .unavailable(error.localizedDescription)
            entries = []
        }
    }
}
