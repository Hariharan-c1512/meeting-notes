import Foundation
enum ActionStatus: String, Codable, CaseIterable, Identifiable {
    case open = "Open"
    case inProgress = "In Progress"
    case done = "Done"

    var id: String { rawValue }
}

// MARK: - Action Item Model

/// A commitment made during a meeting, with an owner, status, and optional due date.
struct ActionItem: Identifiable, Codable, Equatable {
    // MARK: - Properties

    let id: UUID
    var description: String
    var owner: String
    var status: ActionStatus
    var dueDate: Date?

    // MARK: - Initialization

    /// Creates an action item.
    /// - Parameters:
    ///   - id: Unique identifier. Defaults to a new UUID.
    ///   - description: Description of the action commitment.
    ///   - owner: Person assigned to complete the action.
    ///   - status: Current progress status. Defaults to .open.
    ///   - dueDate: Optional target completion date. Defaults to nil.
    init(
        id: UUID = UUID(),
        description: String,
        owner: String,
        status: ActionStatus = .open,
        dueDate: Date? = nil
    ) {
        self.id = id
        self.description = description
        self.owner = owner
        self.status = status
        self.dueDate = dueDate
    }

    // MARK: - Overdue Calculation

    /// Evaluates whether the action item is overdue relative to a given reference date and calendar.
    /// An item is considered overdue when it is not marked as Done and its due date is strictly before the start of the current day.
    /// - Parameters:
    ///   - referenceDate: The comparison date, defaulting to now.
    ///   - calendar: Calendar used for date component calculation.
    /// - Returns: True if overdue, false otherwise.
    func isOverdue(relativeTo referenceDate: Date = Date(), calendar: Calendar = .current) -> Bool {
        guard status != .done, let dueDate = dueDate else { return false }
        return dueDate < calendar.startOfDay(for: referenceDate)
    }

    /// True if the item is not done and its due date precedes today.
    var isOverdue: Bool {
        isOverdue(relativeTo: Date())
    }
}
