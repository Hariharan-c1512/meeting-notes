import Foundation

/// A recorded meeting. Pure data: contains no UI or persistence code.
struct Meeting: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var date: Date
    var project: Project
    var attendees: [String]
    var discussionPoints: [String]
    var decisions: [String]
    var actionItems: [ActionItem]

    /// Action items that are not yet Done (Open or In Progress).
    var openActionItemCount: Int {
        actionItems.filter { $0.status != .done }.count
    }

    /// Action items marked as Done.
    var completedActionItemCount: Int {
        actionItems.filter { $0.status == .done }.count
    }
}
