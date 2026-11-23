import Combine
import Foundation

// MARK: - Meeting Detail View Model

/// Provides one meeting to the detail screen and handles action item status changes and deletion.
@MainActor
final class MeetingDetailViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published private(set) var meeting: Meeting?

    // MARK: - Dependencies

    private let store: MeetingStore

    // MARK: - Initialization

    /// Creates a view model observing a specific meeting ID.
    /// - Parameters:
    ///   - meetingID: Identifier of the meeting to observe.
    ///   - store: The backing data store.
    init(meetingID: UUID, store: MeetingStore) {
        self.store = store
        store.$meetings
            .map { meetings in meetings.first(where: { $0.id == meetingID }) }
            .assign(to: &$meeting)
    }

    // MARK: - Actions

    /// Changes the status of one action item and saves the meeting.
    /// - Parameters:
    ///   - item: The action item to modify.
    ///   - status: The new progress status.
    func updateStatus(of item: ActionItem, to status: ActionStatus) {
        guard var updatedMeeting = meeting,
              let index = updatedMeeting.actionItems.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        updatedMeeting.actionItems[index].status = status
        store.update(updatedMeeting)
    }

    /// Permanently deletes the current meeting.
    func deleteMeeting() {
        guard let meeting else { return }
        store.delete(meeting)
    }
}
