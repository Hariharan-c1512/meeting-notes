import Combine
import Foundation

/// Holds the meeting list, search text, and project filter. Produces the filtered list for the View.
@MainActor
final class MeetingListViewModel: ObservableObject {
    @Published private(set) var meetings: [Meeting] = []
    @Published var searchText = ""
    /// nil means "All Projects".
    @Published var selectedProject: Project?

    private let store: MeetingStore

    init(store: MeetingStore) {
        self.store = store
        store.$meetings.assign(to: &$meetings)
    }

    /// Meetings that match the search text (title or attendee name) and the selected project.
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

    func delete(_ meeting: Meeting) {
        store.delete(meeting)
    }
}
