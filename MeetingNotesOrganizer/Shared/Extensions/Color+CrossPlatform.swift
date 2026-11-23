import SwiftUI

// MARK: - Cross-Platform Color Helpers

extension Color {
    /// Semantic secondary card background that works across both iOS and macOS.
    static var secondarySystemCardBackground: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemBackground)
        #elseif os(macOS)
        return Color(nsColor: .windowBackgroundColor)
        #else
        return Color.secondary.opacity(0.12)
        #endif
    }
}
