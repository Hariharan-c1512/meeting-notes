import Combine
import Foundation

/// Provides one meeting to the detail screen and handles status changes and deletion.
@MainActor
final class MeetingDetailViewModel: ObservableObject {
    @Published private(set) var meeting: Meeting?

    private let store: MeetingStore

    init(meetingID: UUID, store: MeetingStore) {
        self.store = store
        store.$meetings
            .map { meetings in meetings.first(where: { $0.id == meetingID }) }
            .assign(to: &$meeting)
    }

    /// Changes the status of one action item and saves the meeting.
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
