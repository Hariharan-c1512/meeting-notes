import SwiftUI

// MARK: - Status Badge View

/// Colored capsule visual displaying an action item's status.
struct StatusBadge: View {
    // MARK: - Properties

    let status: ActionStatus

    // MARK: - Body

    var body: some View {
        Text(status.rawValue)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(status.tint.opacity(0.2))
            .foregroundStyle(status.tint)
            .clipShape(Capsule())
    }
}
