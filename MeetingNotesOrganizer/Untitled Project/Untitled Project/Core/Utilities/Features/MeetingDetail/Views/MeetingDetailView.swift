import SwiftUI

/// Full view of one meeting: details, attendees, discussion, decisions, and action items with status.
/// Also provides Edit and Delete actions.
struct MeetingDetailView: View {
    @StateObject private var viewModel: MeetingDetailViewModel
    @State private var showingEdit = false
    @State private var showingDeleteConfirmation = false
    @Environment(\.dismiss) private var dismiss
    private let store: MeetingStore

    init(meetingID: UUID, store: MeetingStore) {
        self.store = store
        _viewModel = StateObject(wrappedValue: MeetingDetailViewModel(meetingID: meetingID, store: store))
    }

    var body: some View {
        Group {
            if let meeting = viewModel.meeting {
                detailContent(for: meeting)
            } else {
                EmptyStateView(
                    systemImage: "questionmark.folder",
                    title: "Meeting not found",
                    message: "This meeting may have been deleted."
                )
            }
        }
        .navigationTitle("Meeting Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailContent(for meeting: Meeting) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CardView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(meeting.title)
                            .font(.title2.bold())
                        Label(meeting.date.formatted(date: .complete, time: .shortened), systemImage: "calendar")
                        Label(meeting.project.rawValue, systemImage: "folder")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                SectionCard(title: "Attendees", systemImage: "person.2") {
                    bulletList(meeting.attendees, emptyText: "No attendees recorded.")
                }

                SectionCard(title: "Discussion Points", systemImage: "text.bubble") {
                    bulletList(meeting.discussionPoints, emptyText: "No discussion points recorded.")
                }

                SectionCard(title: "Decisions", systemImage: "checkmark.seal") {
                    bulletList(meeting.decisions, emptyText: "No decisions recorded.")
                }

                SectionCard(title: "Action Items", systemImage: "checklist") {
                    actionItemList(meeting.actionItems)
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showingEdit = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive) {
                        showingDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .confirmationDialog(
            "Delete this meeting?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                viewModel.deleteMeeting()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This cannot be undone.")
        }
        .sheet(isPresented: $showingEdit) {
            EditMeetingView(store: store, meeting: meeting)
        }
    }

    private func bulletList(_ items: [String], emptyText: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            if items.isEmpty {
                Text(emptyText)
                    .foregroundStyle(.secondary)
            }
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                Text("• \(item)")
            }
        }
    }

    private func actionItemList(_ items: [ActionItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if items.isEmpty {
                Text("No action items.")
                    .foregroundStyle(.secondary)
            }
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.description)
                        .font(.subheadline.weight(.semibold))
                    HStack {
                        Label(item.owner, systemImage: "person")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        statusMenu(for: item)
                    }
                }
                Divider()
            }
        }
    }

    /// Tapping the badge lets the user change the status of the action item.
    private func statusMenu(for item: ActionItem) -> some View {
        Menu {
            ForEach(ActionStatus.allCases) { status in
                Button(status.rawValue) {
                    viewModel.updateStatus(of: item, to: status)
                }
            }
        } label: {
            StatusBadge(status: item.status)
        }
    }
}
