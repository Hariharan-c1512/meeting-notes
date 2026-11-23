import Foundation

/// Progress state of an action item.
enum ActionStatus: String, Codable, CaseIterable, Identifiable {
    case open = "Open"
    case inProgress = "In Progress"
    case done = "Done"

    var id: String { rawValue }
}

/// A commitment made during a meeting, with an owner and a status.
struct ActionItem: Identifiable, Codable, Equatable {
    let id: UUID
    var description: String
    var owner: String
    var status: ActionStatus
}
