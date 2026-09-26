import SwiftUI

/// The clock face of a round.
///
/// The full circle is one beat. The bright arc straddling 12 o'clock is the tolerance
/// window — the player has to land the tap while the sweep is inside it. As the window
/// narrows over the round, so does the arc, which is the whole difficulty curve made
/// visible in one shape.
struct BeatRing: View {

    let progress: Double
    let tolerance: Double
    let tint: Color
    let isActive: Bool

    private let lineWidth: CGFloat = 14

    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.08), lineWidth: lineWidth)

            windowArc(from: 1 - tolerance, to: 1)
            windowArc(from: 0, to: tolerance)

            Circle()
                .trim(from: 0, to: min(progress, 1))
                .stroke(
                    tint.gradient,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .shadow(color: tint.opacity(0.6), radius: isActive ? 18 : 0)
        }
        .rotationEffect(.degrees(-90))
        .animation(.linear(duration: 0.05), value: progress)
    }

    /// One half of the tolerance window. The window wraps across the top of the circle,
    /// so it is drawn as two arcs rather than one.
    private func windowArc(from start: Double, to end: Double) -> some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(
                .yellowishGreen.opacity(isActive ? 0.85 : 0.35),
                style: StrokeStyle(lineWidth: lineWidth + 6, lineCap: .butt)
            )
    }
}

#Preview {
    BeatRing(progress: 0.82, tolerance: 0.1, tint: .robinSEgg, isActive: true)
        .padding(60)
        .background(.black)
}
