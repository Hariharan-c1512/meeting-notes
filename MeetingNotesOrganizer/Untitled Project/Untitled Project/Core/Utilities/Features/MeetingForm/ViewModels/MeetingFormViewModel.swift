import Combine
import Foundation

/// Form state and validation shared by the Add and Edit screens.
/// Holds only data and rules; the View renders it.
@MainActor
final class MeetingFormViewModel: ObservableObject {
    @Published var title: String
    @Published var date: Date
    @Published var project: Project
    /// Attendees separated by commas or new lines.
    @Published var attendeesText: String
    /// One discussion point per line.
    @Published var discussionText: String
    /// One decision per line.
    @Published var decisionsText: String
    @Published var actionItems: [ActionItem]
    @Published private(set) var validationMessage: String?

    private let store: MeetingStore
    private let existingID: UUID?

    var isEditing: Bool {
        existingID != nil
    }

    /// Creates an empty form for a new meeting.
    init(store: MeetingStore) {
        self.store = store
        self.existingID = nil
        self.title = ""
        self.date = Date()
        self.project = .department
        self.attendeesText = ""
        self.discussionText = ""
        self.decisionsText = ""
        self.actionItems = [ActionItem(id: UUID(), description: "", owner: "", status: .open)]
    }

    /// Creates a form pre-filled with an existing meeting.
    init(store: MeetingStore, meeting: Meeting) {
        self.store = store
        self.existingID = meeting.id
        self.title = meeting.title
        self.date = meeting.date
        self.project = meeting.project
        self.attendeesText = meeting.attendees.joined(separator: ", ")
        self.discussionText = meeting.discussionPoints.joined(separator: "\n")
        self.decisionsText = meeting.decisions.joined(separator: "\n")
        self.actionItems = meeting.actionItems
    }

    func addActionItem() {
        actionItems.append(ActionItem(id: UUID(), description: "", owner: "", status: .open))
    }

    /// Removes the action items at the given positions (used by swipe-to-delete).
    func removeActionItems(at offsets: IndexSet) {
        for offset in offsets.sorted(by: >) {
            actionItems.remove(at: offset)
        }
    }

    /// Validates the form and saves it. Returns true when the meeting was saved.
    func save() -> Bool {
        let trimmedTitle = title.trimmed
        guard !trimmedTitle.isEmpty else {
            validationMessage = "Title is required."
            return false
        }

        let attendees = attendeesText.splitItems(by: CharacterSet(charactersIn: ",\n"))
        guard !attendees.isEmpty else {
            validationMessage = "Add at least one attendee."
            return false
        }

        // Ignore empty action item rows; keep the rest after trimming.
        let cleanedItems = actionItems
            .map { ActionItem(id: $0.id, description: $0.description.trimmed, owner: $0.owner.trimmed, status: $0.status) }
            .filter { !$0.description.isEmpty }

        guard cleanedItems.allSatisfy({ !$0.owner.isEmpty }) else {
            validationMessage = "Every action item needs an owner."
            return false
        }

        let meeting = Meeting(
            id: existingID ?? UUID(),
            title: trimmedTitle,
            date: date,
            project: project,
            attendees: attendees,
            discussionPoints: discussionText.splitItems(by: .newlines),
            decisions: decisionsText.splitItems(by: .newlines),
            actionItems: cleanedItems
        )

        if isEditing {
            store.update(meeting)
        } else {
            store.add(meeting)
        }
        validationMessage = nil
        return true
    }
}
