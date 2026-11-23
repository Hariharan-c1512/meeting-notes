import Combine
import Foundation

// MARK: - Meeting List View Model

/// Holds the meeting list, search filter, and project filter. Produces the filtered list for the View.
@MainActor
final class MeetingListViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published private(set) var meetings: [Meeting] = []
    @Published var searchText = ""
    /// nil means "All Projects".
    @Published var selectedProject: Project?

    // MARK: - Dependencies

    private let store: MeetingStore

    // MARK: - Initialization

    /// Initializes MeetingListViewModel and subscribes to store updates.
    /// - Parameter store: Data store providing meetings.
    init(store: MeetingStore) {
        self.store = store
        store.$meetings.assign(to: &$meetings)
    }

    // MARK: - Filtered Meetings

    /// Meetings matching the search text (title or attendee name) and project filter.
    var filteredMeetings: [Meeting] {
        let query = searchText.trimmed
        return meetings.filter { meeting in
            let matchesProject = selectedProject == nil || meeting.project == selectedProject
            let matchesSearch = query.isEmpty
                || meeting.title.localizedCaseInsensitiveContains(query)
                || meeting.attendees.contains { $0.localizedCaseInsensitiveContains(query) }
            return matchesProject && matchesSearch
        }
    }

    // MARK: - Actions

    /// Requests deletion of a meeting from the store.
    /// - Parameter meeting: The meeting to delete.
    func delete(_ meeting: Meeting) {
        store.delete(meeting)
    }
}
