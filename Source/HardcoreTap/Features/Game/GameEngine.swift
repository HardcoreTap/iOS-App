import Foundation
import Observation

/// Drives a round of HardcoreTap.
///
/// The legacy implementation counted hundredths in a repeating `Timer` and compared
/// integer counters. This version keeps a single `ContinuousClock.Instant` for the
/// start of the round and derives everything from it, so the judgement is as accurate
/// as the clock rather than as accurate as the timer's drift.
///
/// Every method takes the current instant explicitly, which keeps the whole engine
/// deterministic and testable without waiting on wall-clock time.
@MainActor
@Observable
final class GameEngine {

    enum Phase: Equatable {
        case idle
        case playing
        case over(Defeat)
    }

    /// Why the round ended.
    enum Defeat: Equatable {
        /// The beat came and went without a tap.
        case missed
        /// A tap landed outside the tolerance window.
        case offBeat(error: TimeInterval)
    }

    enum TapOutcome: Equatable {
        case started
        case hit(error: TimeInterval)
        case defeat(Defeat)
        /// Tapped during the cool-down right after a defeat.
        case ignored
    }

    /// The original game refused to restart for half a second after a defeat, so a
    /// panicked double tap could not immediately burn the next round.
    static let restartDelay: TimeInterval = 0.5

    private(set) var phase: Phase = .idle
    private(set) var score = 0
    private(set) var elapsed: TimeInterval = 0
    /// Signed offset of the most recent accepted tap; negative means early.
    private(set) var lastError: TimeInterval?

    /// Callers only change this between rounds; the mode picker is disabled while
    /// playing, since switching mid-round would rewrite the rules under the player.
    var mode: GameMode = .normal

    private var startedAt: ContinuousClock.Instant?
    private var endedAt: ContinuousClock.Instant?
    private var ticker: Task<Void, Never>?

    /// Elapsed time at which the next tap is due.
    var nextBeat: TimeInterval { TimeInterval(score + 1) }

    /// Half-width of the window the next beat is judged against.
    var tolerance: TimeInterval { mode.tolerance(forScore: score) }

    /// 0 right after the previous beat, 1 when the next one is due. Beats are a second
    /// apart, so this is just the fractional part of `elapsed` measured from the last
    /// scored beat. Clamped above 1 so a late-but-still-legal tap keeps the ring visible.
    var beatProgress: Double {
        guard phase == .playing else { return 0 }
        return min(max(elapsed - TimeInterval(score), 0), 1.4)
    }

    /// Seconds until the next beat; negative once it is overdue.
    var timeToBeat: TimeInterval { nextBeat - elapsed }

    var isPlaying: Bool { phase == .playing }

    // MARK: - Round lifecycle

    func start(now: ContinuousClock.Instant = .now) {
        score = 0
        elapsed = 0
        lastError = nil
        startedAt = now
        endedAt = nil
        phase = .playing
        startTicking()
    }

    func reset() {
        stopTicking()
        phase = .idle
        score = 0
        elapsed = 0
        lastError = nil
        startedAt = nil
        endedAt = nil
    }

    /// Recomputes `elapsed` and ends the round if the beat has been missed.
    func advance(to now: ContinuousClock.Instant) {
        guard phase == .playing, let startedAt else { return }
        elapsed = now.durationSince(startedAt)
        if elapsed - nextBeat > tolerance {
            end(.missed, at: now)
        }
    }

    /// Feeds a tap to the engine. Also starts the round when idle, so the player can
    /// begin by tapping anywhere rather than hunting for a button.
    @discardableResult
    func tap(now: ContinuousClock.Instant = .now) -> TapOutcome {
        switch phase {
        case .idle:
            start(now: now)
            return .started

        case .over:
            guard let endedAt, now.durationSince(endedAt) >= Self.restartDelay else {
                return .ignored
            }
            start(now: now)
            return .started

        case .playing:
            guard let startedAt else { return .ignored }
            elapsed = now.durationSince(startedAt)
            let error = elapsed - nextBeat
            // The window is inclusive; epsilon absorbs binary floating-point noise.
            guard abs(error) <= tolerance + 1e-9 else {
                let defeat = Defeat.offBeat(error: error)
                end(defeat, at: now)
                return .defeat(defeat)
            }
            score += 1
            lastError = error
            return .hit(error: error)
        }
    }

    // MARK: - Private

    private func end(_ defeat: Defeat, at now: ContinuousClock.Instant) {
        stopTicking()
        endedAt = now
        phase = .over(defeat)
    }

    /// Polls faster than any display refresh so a missed beat is detected promptly and
    /// the on-screen clock stays smooth.
    private func startTicking() {
        stopTicking()
        ticker = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(8))
                guard let self, self.isPlaying else { return }
                self.advance(to: .now)
            }
        }
    }

    private func stopTicking() {
        ticker?.cancel()
        ticker = nil
    }
}

private extension ContinuousClock.Instant {
    /// Seconds between `other` and self, as the plain `TimeInterval` the game reasons in.
    func durationSince(_ other: ContinuousClock.Instant) -> TimeInterval {
        let duration = other.duration(to: self)
        return TimeInterval(duration.components.seconds)
            + TimeInterval(duration.components.attoseconds) / 1e18
    }
}
