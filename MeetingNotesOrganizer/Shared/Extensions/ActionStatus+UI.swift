import SwiftUI

// MARK: - ActionStatus UI Presentation

/// UI-only presentation details for ActionStatus. Kept separate from the core model.
extension ActionStatus {
    /// Semantic tint color associated with the action item status.
    var tint: Color {
        switch self {
        case .open:
            return .orange
        case .inProgress:
            return .blue
        case .done:
            return .green
        }
    }
}
