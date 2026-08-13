import SwiftUI

/// A transient banner. Replaces the SwiftEntryKit dependency the 2019 rewrite pulled
/// in — SwiftUI plus the iOS 26 glass material covers the same ground with no package.
struct Toast: Identifiable, Equatable {

    enum Kind: Equatable {
        case success
        case failure
        case neutral

        var tint: Color {
            switch self {
            case .success: .yellowishGreen
            case .failure: .lipstick
            case .neutral: .robinSEgg
            }
        }

        var symbol: String {
            switch self {
            case .success: "trophy.fill"
            case .failure: "xmark.circle.fill"
            case .neutral: "info.circle.fill"
            }
        }
    }

    let id = UUID()
    var text: String
    var kind: Kind = .neutral
}

@MainActor
@Observable
final class ToastCenter {

    private(set) var current: Toast?
    private var dismissal: Task<Void, Never>?

    func show(_ text: String, kind: Toast.Kind = .neutral, for duration: Duration = .seconds(3)) {
        dismissal?.cancel()
        current = Toast(text: text, kind: kind)
        dismissal = Task { [weak self] in
            try? await Task.sleep(for: duration)
            guard !Task.isCancelled else { return }
            self?.current = nil
        }
    }

    func dismiss() {
        dismissal?.cancel()
        current = nil
    }
}

private struct ToastLayer: ViewModifier {
    let center: ToastCenter

    func body(content: Content) -> some View {
        content.overlay(alignment: .top) {
            if let toast = center.current {
                ToastBanner(toast: toast)
                    .onTapGesture { center.dismiss() }
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.snappy, value: center.current)
    }
}

private struct ToastBanner: View {
    let toast: Toast

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.kind.symbol)
                .font(.title3)
                .foregroundStyle(toast.kind.tint)
            Text(toast.text)
                .font(.subheadline.weight(.medium))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 18)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}

extension View {
    func toastLayer(_ center: ToastCenter) -> some View {
        modifier(ToastLayer(center: center))
    }
}
