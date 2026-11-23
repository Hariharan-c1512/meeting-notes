import XCTest
@testable import MeetingNotesOrganizer

// MARK: - Meeting Form View Model Tests

/// Unit test suite verifying MeetingFormViewModel validation and persistence behavior.
@MainActor
final class MeetingFormViewModelTests: XCTestCase {
    // MARK: - Properties

    private var temporaryFileURL: URL = URL(fileURLWithPath: "")
    private var store: MeetingStore = MeetingStore(fileURL: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("placeholder.json"))

    // MARK: - Setup & Teardown

    override func setUp() async throws {
        let uniqueName = "test_meetings_\(UUID().uuidString).json"
        temporaryFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(uniqueName)

        // Pre-create an empty JSON file so the store starts empty without seeding sample data
        let emptyPayload = try JSONEncoder().encode([Meeting]())
        try emptyPayload.write(to: temporaryFileURL)

        store = MeetingStore(fileURL: temporaryFileURL)
    }

    override func tearDown() async throws {
        if FileManager.default.fileExists(atPath: temporaryFileURL.path) {
            try? FileManager.default.removeItem(at: temporaryFileURL)
        }
    }

    // MARK: - Test Cases

    /// Verifies that saving fails when the meeting title is empty.
    func testSaveFailsWithEmptyTitle() {
        let viewModel = MeetingFormViewModel(store: store)
        viewModel.title = "   "
        viewModel.attendeesText = "Alice, Bob"

        let didSave = viewModel.save()

        XCTAssertFalse(didSave, "Saving should fail when title is empty.")
        XCTAssertEqual(viewModel.validationMessage, "Title is required.")
    }

    /// Verifies that saving fails when an action item has a description but lacks an owner.
    func testSaveFailsWithMissingActionItemOwner() {
        let viewModel = MeetingFormViewModel(store: store)
        viewModel.title = "Sprint Kickoff"
        viewModel.attendeesText = "Alice, Bob"
        viewModel.actionItems = [
            ActionItem(
                id: UUID(),
                description: "Setup test pipeline",
                owner: "   ",
                status: .open,
                dueDate: Date()
            )
        ]

        let didSave = viewModel.save()

        XCTAssertFalse(didSave, "Saving should fail when an action item has no owner.")
        XCTAssertEqual(viewModel.validationMessage, "Every action item needs an owner.")
    }

    /// Verifies that saving succeeds with valid title, attendees, and action item details.
    func testSaveSucceedsWithValidData() {
        let viewModel = MeetingFormViewModel(store: store)
        viewModel.title = "Architecture Review"
        viewModel.attendeesText = "Alice, Bob, Charlie"
        viewModel.discussionText = "Discussed modular boundaries"
        viewModel.decisionsText = "Adopt SPM for core packages"
        viewModel.actionItems = [
            ActionItem(
                id: UUID(),
                description: "Write RFC document",
                owner: "Alice",
                status: .open,
                dueDate: Date().addingTimeInterval(86_400 * 5)
            )
        ]

        let didSave = viewModel.save()

        XCTAssertTrue(didSave, "Saving should succeed with complete and valid data.")
        XCTAssertNil(viewModel.validationMessage, "Validation message should be nil after successful save.")

        XCTAssertTrue(
            store.meetings.contains { $0.title == "Architecture Review" },
            "Meeting should be persisted into the store."
        )
    }
}
