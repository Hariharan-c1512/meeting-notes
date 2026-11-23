import XCTest
@testable import MeetingNotesOrganizer

// MARK: - Action Item Overdue Tests

/// Unit test suite verifying overdue calculations for ActionItem.
final class ActionItemOverdueTests: XCTestCase {
    // MARK: - Properties

    private let calendar = Calendar.current
    private let referenceDate = Date()

    // MARK: - Test Cases

    /// Verifies that completed items are never overdue, even when their due date is in the past.
    func testCompletedItemIsNotOverdueEvenIfPastDue() {
        let yesterday = calendar.date(byAdding: .day, value: -1, to: referenceDate)
        let item = ActionItem(
            id: UUID(),
            description: "Submit report",
            owner: "Alice",
            status: .done,
            dueDate: yesterday
        )

        XCTAssertFalse(
            item.isOverdue(relativeTo: referenceDate, calendar: calendar),
            "Completed items should not be marked as overdue."
        )
    }

    /// Verifies that open or in-progress items due before today are overdue.
    func testOpenItemWithPastDueDateIsOverdue() {
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: referenceDate)
        let openItem = ActionItem(
            id: UUID(),
            description: "Prepare presentation",
            owner: "Bob",
            status: .open,
            dueDate: twoDaysAgo
        )
        let inProgressItem = ActionItem(
            id: UUID(),
            description: "Draft budget",
            owner: "Charlie",
            status: .inProgress,
            dueDate: twoDaysAgo
        )

        XCTAssertTrue(
            openItem.isOverdue(relativeTo: referenceDate, calendar: calendar),
            "Open item due before today should be overdue."
        )
        XCTAssertTrue(
            inProgressItem.isOverdue(relativeTo: referenceDate, calendar: calendar),
            "In-progress item due before today should be overdue."
        )
    }

    /// Verifies that items due in the future are not overdue.
    func testItemWithFutureDueDateIsNotOverdue() {
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: referenceDate)
        let item = ActionItem(
            id: UUID(),
            description: "Send invite",
            owner: "Dana",
            status: .open,
            dueDate: tomorrow
        )

        XCTAssertFalse(
            item.isOverdue(relativeTo: referenceDate, calendar: calendar),
            "Items due in the future should not be overdue."
        )
    }

    /// Verifies that items without a due date are never overdue.
    func testItemWithoutDueDateIsNotOverdue() {
        let item = ActionItem(
            id: UUID(),
            description: "Backlog task",
            owner: "Eve",
            status: .open,
            dueDate: nil
        )

        XCTAssertFalse(
            item.isOverdue(relativeTo: referenceDate, calendar: calendar),
            "Items without a due date cannot be overdue."
        )
    }

    /// Verifies that items due today are not overdue because they are not due before today.
    func testItemDueTodayIsNotOverdue() {
        let startOfToday = calendar.startOfDay(for: referenceDate)
        let item = ActionItem(
            id: UUID(),
            description: "End of day review",
            owner: "Frank",
            status: .open,
            dueDate: startOfToday
        )

        XCTAssertFalse(
            item.isOverdue(relativeTo: referenceDate, calendar: calendar),
            "Items due today are not overdue."
        )
    }
}
