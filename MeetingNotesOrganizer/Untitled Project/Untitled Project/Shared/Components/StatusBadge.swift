import SwiftUI

/// Colored capsule that shows an action item's status.
struct StatusBadge: View {
    let status: ActionStatus

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
