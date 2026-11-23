import Combine
import Foundation

// MARK: - Meeting Form View Model

/// Form state and validation shared by the Add and Edit meeting screens.
/// Enforces business rules and prepares data for persistence.
@MainActor
final class MeetingFormViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var title: String
    @Published var date: Date
    @Published var project: Project
    /// Attendees separated by commas or newlines.
    @Published var attendeesText: String
    /// One discussion point per line.
    @Published var discussionText: String
    /// One decision per line.
    @Published var decisionsText: String
    @Published var actionItems: [ActionItem]
    @Published private(set) var validationMessage: String?

    // MARK: - Private Dependencies & State

    private let store: MeetingStore
    private let existingID: UUID?

    // MARK: - Computed Properties

    /// Indicates whether this form is editing an existing meeting.
    var isEditing: Bool {
        existingID != nil
    }

    // MARK: - Initialization

    /// Creates an empty form configured for creating a new meeting.
    /// - Parameter store: The data store to persist changes into.
    init(store: MeetingStore) {
        self.store = store
        self.existingID = nil
        self.title = ""
        self.date = Date()
        self.project = .department
        self.attendeesText = ""
        self.discussionText = ""
        self.decisionsText = ""
        self.actionItems = [ActionItem(id: UUID(), description: "", owner: "", status: .open, dueDate: nil)]
    }

    /// Creates a form pre-populated with data from an existing meeting.
    /// - Parameters:
    ///   - store: The data store to persist updates into.
    ///   - meeting: The meeting to edit.
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

    // MARK: - Action Item Management

    /// Appends a new blank action item row to the form.
    func addActionItem() {
        actionItems.append(ActionItem(id: UUID(), description: "", owner: "", status: .open, dueDate: nil))
    }

    /// Removes action items at the specified offsets.
    /// - Parameter offsets: The set of indices to remove.
    func removeActionItems(at offsets: IndexSet) {
        for offset in offsets.sorted(by: >) {
            actionItems.remove(at: offset)
        }
    }

    // MARK: - Save & Validation

    /// Validates user input and saves or updates the meeting in the store.
    /// - Returns: True if validation succeeded and the meeting was saved; otherwise false.
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

        // Clean action items: ignore empty description rows, preserve due date, require owner for non-empty items
        let cleanedItems = actionItems
            .map {
                ActionItem(
                    id: $0.id,
                    description: $0.description.trimmed,
                    owner: $0.owner.trimmed,
                    status: $0.status,
                    dueDate: $0.dueDate
                )
            }
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
