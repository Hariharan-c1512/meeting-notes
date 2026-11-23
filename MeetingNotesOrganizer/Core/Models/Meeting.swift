import Foundation

// MARK: - Meeting Model

/// A recorded meeting record. Contains metadata, attendees, discussion points, decisions, and action items.
struct Meeting: Identifiable, Codable, Equatable {
    // MARK: - Properties

    let id: UUID
    var title: String
    var date: Date
    var project: Project
    var attendees: [String]
    var discussionPoints: [String]
    var decisions: [String]
    var actionItems: [ActionItem]

    // MARK: - Computed Properties

    /// Action items that are not yet Done (Open or In Progress).
    var openActionItemCount: Int {
        actionItems.filter { $0.status != .done }.count
    }

    /// Action items marked as Done.
    var completedActionItemCount: Int {
        actionItems.filter { $0.status == .done }.count
    }

    /// Action items that are not Done and past their due date.
    var overdueActionItemCount: Int {
        actionItems.filter { $0.isOverdue }.count
    }
}
