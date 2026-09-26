import Testing
import Foundation
@testable import HardcoreTap

/// The engine takes the current instant on every call, so a whole round can be played
/// out in a test without a single real second passing.
@MainActor
struct GameEngineTests {

    private let origin = ContinuousClock.now

    private func instant(_ seconds: Double) -> ContinuousClock.Instant {
        origin.advanced(by: .seconds(seconds))
    }

    // MARK: - Tolerance curve

    @Test func normalToleranceShrinksToFloor() {
        let mode = GameMode.normal
        #expect(mode.tolerance(forScore: 0) == 0.10)
        #expect(abs(mode.tolerance(forScore: 3) - 0.07) < 1e-9)
        #expect(mode.tolerance(forScore: 5) == 0.05)
        // Never narrower than the floor, however long the round runs.
        #expect(mode.tolerance(forScore: 500) == 0.05)
    }

    @Test func hardcoreToleranceIsFlat() {
        #expect(GameMode.hardcore.tolerance(forScore: 0) == 0.01)
        #expect(GameMode.hardcore.tolerance(forScore: 42) == 0.01)
    }

    // MARK: - Judging taps

    @Test func firstTapStartsTheRound() {
        let engine = GameEngine()
        #expect(engine.tap(now: instant(0)) == .started)
        #expect(engine.isPlaying)
        #expect(engine.score == 0)
    }

    @Test func tapOnTheBeatScores() {
        let engine = GameEngine()
        engine.start(now: instant(0))
        let outcome = engine.tap(now: instant(1.0))

        #expect(engine.score == 1)
        guard case .hit(let error) = outcome else {
            Issue.record("expected a hit, got \(outcome)")
            return
        }
        #expect(abs(error) < 1e-9)
    }

    @Test func tapInsideToleranceScores() {
        let engine = GameEngine()
        engine.start(now: instant(0))
        engine.tap(now: instant(1.09)) // window is ±0.10 for the first beat

        #expect(engine.score == 1)
        #expect(engine.isPlaying)
    }

    @Test func tapOutsideToleranceEndsTheRound() {
        let engine = GameEngine()
        engine.start(now: instant(0))
        let outcome = engine.tap(now: instant(1.2))

        #expect(engine.score == 0)
        #expect(!engine.isPlaying)
        guard case .defeat(.offBeat(let error)) = outcome else {
            Issue.record("expected a defeat, got \(outcome)")
            return
        }
        #expect(abs(error - 0.2) < 1e-9)
    }

    @Test func tappingTooEarlyEndsTheRound() {
        let engine = GameEngine()
        engine.start(now: instant(0))
        engine.tap(now: instant(0.5))

        #expect(engine.phase == .over(.offBeat(error: -0.5)))
    }

    @Test func toleranceNarrowsAsTheRoundGoesOn() {
        let engine = GameEngine()
        engine.start(now: instant(0))

        // 0.09 s of slack is fine on beat 1 but fatal once the window has shrunk.
        for beat in 1...5 {
            engine.tap(now: instant(Double(beat)))
        }
        #expect(engine.score == 5)
        #expect(engine.tolerance == 0.05)

        engine.tap(now: instant(6.09))
        #expect(!engine.isPlaying)
    }

    // MARK: - Missed beats

    @Test func beatThatIsNeverTappedEndsTheRound() {
        let engine = GameEngine()
        engine.start(now: instant(0))

        engine.advance(to: instant(1.05)) // late, still inside the window
        #expect(engine.isPlaying)

        engine.advance(to: instant(1.2))
        #expect(engine.phase == .over(.missed))
    }

    @Test func advanceTracksElapsedTime() {
        let engine = GameEngine()
        engine.start(now: instant(0))
        engine.advance(to: instant(0.42))

        #expect(abs(engine.elapsed - 0.42) < 1e-6)
        #expect(abs(engine.beatProgress - 0.42) < 1e-6)
    }

    @Test func beatProgressResetsAfterEachBeat() {
        let engine = GameEngine()
        engine.start(now: instant(0))
        engine.tap(now: instant(1.0))
        engine.advance(to: instant(1.3))

        // Progress is measured from the last scored beat, not from the round start.
        #expect(abs(engine.beatProgress - 0.3) < 1e-6)
    }

    // MARK: - Restarting

    @Test func restartIsBlockedDuringTheCooldown() {
        let engine = GameEngine()
        engine.start(now: instant(0))
        engine.tap(now: instant(1.5)) // defeat at t = 1.5

        #expect(engine.tap(now: instant(1.7)) == .ignored)
        #expect(engine.tap(now: instant(2.1)) == .started)
        #expect(engine.isPlaying)
        #expect(engine.score == 0)
    }

    @Test func resetReturnsToIdle() {
        let engine = GameEngine()
        engine.start(now: instant(0))
        engine.tap(now: instant(1.0))
        engine.reset()

        #expect(engine.phase == .idle)
        #expect(engine.score == 0)
        #expect(engine.elapsed == 0)
    }
}

@MainActor
struct PlayerProfileTests {

    /// A throwaway suite per test, so records never leak between cases.
    private func makeProfile() throws -> (PlayerProfile, UserDefaults) {
        let suite = try #require(UserDefaults(suiteName: "tests.\(UUID().uuidString)"))
        return (PlayerProfile(defaults: suite), suite)
    }

    @Test func recordsOnlyImprovements() throws {
        let (profile, _) = try makeProfile()

        #expect(profile.record(score: 10, mode: .normal))
        #expect(!profile.record(score: 7, mode: .normal))
        #expect(profile.best(for: .normal) == 10)
    }

    @Test func modesKeepSeparateRecords() throws {
        let (profile, _) = try makeProfile()
        profile.record(score: 12, mode: .normal)

        #expect(profile.best(for: .hardcore) == 0)
    }

    @Test func recordsSurviveAcrossInstances() throws {
        let (profile, suite) = try makeProfile()
        profile.nickname = "bogdan"
        profile.record(score: 21, mode: .hardcore)

        let reloaded = PlayerProfile(defaults: suite)
        #expect(reloaded.nickname == "bogdan")
        #expect(reloaded.best(for: .hardcore) == 21)
    }
}
