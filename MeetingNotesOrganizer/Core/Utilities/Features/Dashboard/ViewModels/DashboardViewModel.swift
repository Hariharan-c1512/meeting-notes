import Combine
import Foundation

// MARK: - Dashboard View Model

/// Calculates the Dashboard summary metrics and reflects persistence notices.
@MainActor
final class DashboardViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published private(set) var meetings: [Meeting] = []
    @Published private(set) var dataRecoveryNotice: String?

    // MARK: - Dependencies

    private let store: MeetingStore

    // MARK: - Initialization

    /// Initializes DashboardViewModel and synchronizes with MeetingStore changes.
    /// - Parameter store: The backing data store.
    init(store: MeetingStore) {
        self.store = store
        store.$meetings.assign(to: &$meetings)
        store.$dataRecoveryNotice.assign(to: &$dataRecoveryNotice)
    }

    // MARK: - Computed Metrics

    /// Total number of recorded meetings.
    var totalMeetings: Int {
        meetings.count
    }

    /// Number of action items across all meetings not marked Done.
    var openActionItems: Int {
        meetings.reduce(0) { $0 + $1.openActionItemCount }
    }

    /// Number of action items marked Done.
    var completedActionItems: Int {
        meetings.reduce(0) { $0 + $1.completedActionItemCount }
    }

    /// Number of action items across all meetings that are overdue (not Done and due before today).
    var overdueActionItems: Int {
        meetings.reduce(0) { total, meeting in
            total + meeting.actionItems.filter { $0.isOverdue }.count
        }
    }

    /// The most recent meeting by date, or nil if none exist.
    var mostRecentMeeting: Meeting? {
        meetings.max { $0.date < $1.date }
    }

    // MARK: - Notice Actions

    /// Forwards the notice dismissal to the store.
    func dismissRecoveryNotice() {
        store.dismissRecoveryNotice()
    }
}
