import Combine
import Foundation

/// Calculates the Dashboard summary numbers from the meeting list.
@MainActor
final class DashboardViewModel: ObservableObject {
    @Published private(set) var meetings: [Meeting] = []

    /// Mirrors the store so the Dashboard refreshes whenever data changes.
    init(store: MeetingStore) {
        store.$meetings.assign(to: &$meetings)
    }

    var totalMeetings: Int {
        meetings.count
    }

    var openActionItems: Int {
        meetings.reduce(0) { $0 + $1.openActionItemCount }
    }

    var completedActionItems: Int {
        meetings.reduce(0) { $0 + $1.completedActionItemCount }
    }

    var mostRecentMeeting: Meeting? {
        meetings.max { $0.date < $1.date }
    }
}
