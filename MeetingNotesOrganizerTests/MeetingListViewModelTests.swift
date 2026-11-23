import XCTest
@testable import MeetingNotesOrganizer

// MARK: - Meeting List View Model Tests

/// Unit test suite verifying search query and project filtering behavior in MeetingListViewModel.
@MainActor
final class MeetingListViewModelTests: XCTestCase {
    // MARK: - Properties

    private var temporaryFileURL: URL = URL(fileURLWithPath: "")
    private var store: MeetingStore = MeetingStore(fileURL: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("placeholder.json"))

    // MARK: - Setup & Teardown

    override func setUp() async throws {
        let uniqueName = "test_meeting_list_\(UUID().uuidString).json"
        temporaryFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(uniqueName)

        // Pre-create an empty JSON file so the store starts empty without seeding sample data
        let emptyPayload = try JSONEncoder().encode([Meeting]())
        try emptyPayload.write(to: temporaryFileURL)

        store = MeetingStore(fileURL: temporaryFileURL)

        // Seed with controlled test records
        store.add(Meeting(
            id: UUID(),
            title: "SwiftUI Migration Sync",
            date: Date(),
            project: .wiproCoE,
            attendees: ["Kiran Rao", "Meera Sen"],
            discussionPoints: ["Navigation path refactoring"],
            decisions: ["Adopt NavigationStack"],
            actionItems: []
        ))

        store.add(Meeting(
            id: UUID(),
            title: "Security Auditing",
            date: Date().addingTimeInterval(-3600),
            project: .department,
            attendees: ["Arjun Das", "Kiran Rao"],
            discussionPoints: ["Keychain integration"],
            decisions: ["Deprecate UserDefaults auth"],
            actionItems: []
        ))

        store.add(Meeting(
            id: UUID(),
            title: "AI Research Exploration",
            date: Date().addingTimeInterval(-7200),
            project: .research,
            attendees: ["Pooja Hegde"],
            discussionPoints: ["Model evals"],
            decisions: ["Run bench test suite"],
            actionItems: []
        ))
    }

    override func tearDown() async throws {
        if FileManager.default.fileExists(atPath: temporaryFileURL.path) {
            try? FileManager.default.removeItem(at: temporaryFileURL)
        }
    }

    // MARK: - Test Cases

    /// Verifies that searching filters meetings matching by title.
    func testSearchMatchingTitle() {
        let viewModel = MeetingListViewModel(store: store)
        viewModel.searchText = "Migration"

        let results = viewModel.filteredMeetings

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "SwiftUI Migration Sync")
    }

    /// Verifies that searching filters meetings matching by attendee name.
    func testSearchMatchingAttendee() {
        let viewModel = MeetingListViewModel(store: store)
        viewModel.searchText = "Kiran"

        let results = viewModel.filteredMeetings

        XCTAssertEqual(results.count, 2, "Expected 2 meetings with attendee Kiran.")
    }

    /// Verifies that selecting a project filters meetings belonging to that project only.
    func testProjectFiltering() {
        let viewModel = MeetingListViewModel(store: store)
        viewModel.selectedProject = .research

        let results = viewModel.filteredMeetings

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.project, .research)
    }

    /// Verifies that combining search text and project filtering applies both constraints conjunctively.
    func testCombinedSearchAndProjectFilter() {
        let viewModel = MeetingListViewModel(store: store)
        viewModel.selectedProject = .department
        viewModel.searchText = "Security"

        let results = viewModel.filteredMeetings

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Security Auditing")

        // Search for text that does not match within the selected project
        viewModel.searchText = "Migration"
        XCTAssertTrue(viewModel.filteredMeetings.isEmpty, "Migration does not belong to Department project.")
    }
}
