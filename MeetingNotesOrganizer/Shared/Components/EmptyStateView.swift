import SwiftUI

// MARK: - Empty State View

/// Reusable empty state view displaying an icon, title, and descriptive message.
struct EmptyStateView: View {
    // MARK: - Properties

    let systemImage: String
    let title: String
    let message: String

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
}
