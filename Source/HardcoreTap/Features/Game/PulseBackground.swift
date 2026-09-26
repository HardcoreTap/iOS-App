import SwiftUI

/// Successor to the pair of `CAGradientLayer`s the original game slid across the screen
/// once a second. Same idea — the room changes colour on every beat — expressed as a
/// mesh gradient that breathes with the beat instead of two hand-animated layers.
struct PulseBackground: View {

    let beat: Int
    let progress: Double
    let isActive: Bool

    /// The palette the 2017 build cycled through, kept as the app's identity.
    private static let palette: [Color] = [
        .lipstick, .blueberry, .robinSEgg, .yellowishGreen, .darkSkyBlue, .blueBlue,
    ]

    private var current: Color { Self.palette[abs(beat) % Self.palette.count] }
    private var next: Color { Self.palette[abs(beat + 1) % Self.palette.count] }

    /// Loudest right after a beat lands, fading out as the next one approaches.
    private var swell: Double { isActive ? max(0, 1 - progress) : 0.25 }

    var body: some View {
        ZStack {
            Color.black

            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [0.5, Float(0.35 + swell * 0.3)], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1],
                ],
                colors: [
                    .black, current.opacity(0.55), .black,
                    next.opacity(0.35), current.opacity(0.75), next.opacity(0.35),
                    .black, next.opacity(0.5), .black,
                ]
            )
            .opacity(0.35 + swell * 0.45)
            .blur(radius: 40)
        }
        .ignoresSafeArea()
        .animation(.smooth(duration: 0.35), value: beat)
    }
}

#Preview {
    PulseBackground(beat: 2, progress: 0.2, isActive: true)
}
