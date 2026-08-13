import SwiftUI

struct GameScreen: View {

    @Environment(PlayerProfile.self) private var profile
    @Environment(GameCenterService.self) private var gameCenter
    @Environment(Metronome.self) private var metronome
    @Environment(ToastCenter.self) private var toasts
    @Environment(\.scenePhase) private var scenePhase

    @State private var engine = GameEngine()
    @State private var showsSettings = false
    @State private var hitCount = 0
    @State private var missCount = 0

    private var tint: Color {
        switch engine.phase {
        case .over: .lipstick
        case .playing: .robinSEgg
        case .idle: .darkSkyBlue
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PulseBackground(
                    beat: engine.score,
                    progress: engine.beatProgress,
                    isActive: engine.isPlaying
                )

                // The whole board is the button — that is the game.
                Color.clear
                    .contentShape(.rect)
                    .onTapGesture(perform: handleTap)

                VStack(spacing: 32) {
                    scoreboard
                    Spacer()
                    dial
                    Spacer()
                    footer
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .allowsHitTesting(engine.isPlaying == false)
            }
            .navigationTitle("HardcoreTap")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings", systemImage: "gearshape") { showsSettings = true }
                }
            }
            .sheet(isPresented: $showsSettings) { SettingsScreen() }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: hitCount)
        .sensoryFeedback(.error, trigger: missCount)
        .onChange(of: engine.phase) { _, phase in
            // A round can end from a bad tap or from a beat that never came, and the
            // second one never reaches `handleTap`. Settling up here covers both.
            guard case .over = phase else { return }
            missCount += 1
            metronome.stop()
            bankRecord()
        }
        .onChange(of: scenePhase) { _, phase in
            // Leaving the app stops the clock in the player's favour rather than
            // letting them come back to an instant loss.
            if phase != .active { endRoundIfNeeded() }
        }
        .onDisappear { endRoundIfNeeded() }
    }

    // MARK: - Sections

    private var scoreboard: some View {
        HStack(alignment: .top) {
            stat(title: "Score", value: "\(engine.score)")
            Spacer()
            stat(title: "Best", value: "\(profile.best(for: engine.mode))", alignment: .trailing)
        }
    }

    private func stat(
        title: LocalizedStringKey,
        value: String,
        alignment: HorizontalAlignment = .leading
    ) -> some View {
        VStack(alignment: alignment, spacing: 2) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Text(value)
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText())
        }
    }

    private var dial: some View {
        ZStack {
            BeatRing(
                progress: engine.beatProgress,
                tolerance: engine.tolerance,
                tint: tint,
                isActive: engine.isPlaying
            )
            .frame(maxWidth: 280)

            VStack(spacing: 6) {
                Text(clockText)
                    .font(.system(size: 40, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                Text(verbatim: toleranceText)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())
            }
        }
        .animation(.smooth, value: engine.tolerance)
    }

    @ViewBuilder
    private var footer: some View {
        switch engine.phase {
        case .idle:
            idleFooter
        case .playing:
            Text("Tap once every second.")
                .font(.headline)
                .foregroundStyle(.secondary)
        case .over(let defeat):
            gameOverFooter(defeat)
        }
    }

    private var idleFooter: some View {
        VStack(spacing: 20) {
            Picker("Mode", selection: Bindable(engine).mode) {
                ForEach(GameMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            Text(engine.mode.subtitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                handleTap()
            } label: {
                Label("Start", systemImage: "play.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .tint(.lipstick)
        }
    }

    private func gameOverFooter(_ defeat: GameEngine.Defeat) -> some View {
        VStack(spacing: 14) {
            Text(defeatHeadline(defeat))
                .font(.title3.weight(.semibold))
            Text(defeatDetail(defeat))
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button {
                    handleTap()
                } label: {
                    Label("Play again", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.lipstick)

                ShareLink(item: shareText) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            Button("Change mode") { engine.reset() }
                .font(.footnote)
        }
    }

    // MARK: - Behaviour

    private func handleTap() {
        switch engine.tap() {
        case .started:
            metronome.start()
        case .hit:
            hitCount += 1
        case .defeat, .ignored:
            // Defeat is settled in the phase observer, which also catches missed beats.
            break
        }
    }

    /// Backgrounding abandons the round rather than letting the player return to a
    /// clock that ran on without them.
    private func endRoundIfNeeded() {
        guard engine.isPlaying else { return }
        engine.reset()
        metronome.stop()
    }

    private func bankRecord() {
        let score = engine.score
        let mode = engine.mode
        guard profile.record(score: score, mode: mode) else { return }

        toasts.show(String(localized: "New record — \(score) points!"), kind: .success)
        Task { await gameCenter.submit(score: score, mode: mode) }
    }

    // MARK: - Formatting

    private var toleranceText: String {
        // Formatted through the locale so ru gets "0,10" rather than "0.10".
        let value = engine.tolerance.formatted(.number.precision(.fractionLength(2)))
        return String(localized: "±\(value) s", comment: "Tolerance window, e.g. ±0.10 s")
    }

    private var clockText: String {
        let elapsed = max(engine.elapsed, 0)
        let seconds = Int(elapsed)
        let hundredths = Int((elapsed - Double(seconds)) * 100)
        return String(format: "%02d:%02d", seconds, hundredths)
    }

    private var shareText: String {
        String(
            localized: "My HardcoreTap record is \(profile.best(for: engine.mode)). Think you can beat it?"
        )
    }

    private func defeatHeadline(_ defeat: GameEngine.Defeat) -> LocalizedStringKey {
        switch defeat {
        case .missed: "You missed the beat"
        case .offBeat(let error): error < 0 ? "Too early" : "Too late"
        }
    }

    private func defeatDetail(_ defeat: GameEngine.Defeat) -> String {
        switch defeat {
        case .missed:
            String(localized: "The beat came and went. Final score: \(engine.score).")
        case .offBeat(let error):
            String(
                localized: """
                    Off by \(abs(error).formatted(.number.precision(.fractionLength(3)))) s. \
                    Final score: \(engine.score).
                    """
            )
        }
    }
}

#Preview {
    GameScreen()
        .environment(PlayerProfile())
        .environment(GameCenterService())
        .environment(Metronome())
        .environment(ToastCenter())
        .preferredColorScheme(.dark)
}
