import SwiftUI

/// UI-only presentation details for ActionStatus. Kept out of the model so the model stays UI-free.
extension ActionStatus {
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
