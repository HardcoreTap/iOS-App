import AVFoundation
import Observation

/// Loops the 60 BPM backing track the game is timed against.
///
/// Uses the `.ambient` category so the track mixes with — and never interrupts —
/// whatever the player is already listening to.
@MainActor
@Observable
final class Metronome {

    private var player: AVAudioPlayer?
    private var isSessionConfigured = false

    /// Mirrors the "background sound" switch in Settings.
    var isEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isEnabled, forKey: Self.settingKey)
            if !isEnabled { stop() }
        }
    }

    private static let settingKey = "bgSound"

    init() {
        isEnabled = UserDefaults.standard.object(forKey: Self.settingKey) as? Bool ?? true
    }

    func start() {
        guard isEnabled else { return }
        configureSessionIfNeeded()

        if player == nil {
            guard let url = Bundle.main.url(forResource: "bmp60", withExtension: "mp3") else { return }
            player = try? AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.prepareToPlay()
        }
        player?.currentTime = 0
        player?.play()
    }

    func stop() {
        player?.stop()
    }

    private func configureSessionIfNeeded() {
        guard !isSessionConfigured else { return }
        isSessionConfigured = true
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
}
