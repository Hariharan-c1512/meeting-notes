import SwiftUI

// MARK: - Meeting Form View

/// The shared form layout for creating and editing meetings.
struct MeetingFormView: View {
    // MARK: - View Model

    @ObservedObject var viewModel: MeetingFormViewModel

    // MARK: - Body

    var body: some View {
        Form {
            meetingSection
            attendeesSection
            discussionSection
            decisionsSection
            actionItemsSection
            validationSection
        }
    }

    // MARK: - Form Sections

    private var meetingSection: some View {
        Section("Meeting") {
            TextField("Title", text: $viewModel.title)
            DatePicker("Date", selection: $viewModel.date, displayedComponents: [.date, .hourAndMinute])
            Picker("Project", selection: $viewModel.project) {
                ForEach(Project.allCases) { project in
                    Text(project.rawValue).tag(project)
                }
            }
        }
    }

    private var attendeesSection: some View {
        Section {
            TextField("Names separated by commas", text: $viewModel.attendeesText, axis: .vertical)
                .lineLimit(2...5)
        } header: {
            Text("Attendees")
        }
    }

    private var discussionSection: some View {
        Section {
            TextField("One point per line", text: $viewModel.discussionText, axis: .vertical)
                .lineLimit(3...8)
        } header: {
            Text("Discussion Points")
        }
    }

    private var decisionsSection: some View {
        Section {
            TextField("One decision per line", text: $viewModel.decisionsText, axis: .vertical)
                .lineLimit(2...6)
        } header: {
            Text("Decisions")
        }
    }

    private var actionItemsSection: some View {
        Section {
            ForEach($viewModel.actionItems) { $item in
                actionItemRow(for: $item)
            }
            .onDelete { offsets in
                viewModel.removeActionItems(at: offsets)
            }

            Button {
                viewModel.addActionItem()
            } label: {
                Label("Add Action Item", systemImage: "plus.circle")
            }
        } header: {
            Text("Action Items")
        } footer: {
            Text("Swipe a row to remove it.")
        }
    }

    @ViewBuilder
    private func actionItemRow(for item: Binding<ActionItem>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Action item", text: item.description)
            TextField("Owner", text: item.owner)

            Picker("Status", selection: item.status) {
                ForEach(ActionStatus.allCases) { status in
                    Text(status.rawValue).tag(status)
                }
            }

            Toggle("Set Due Date", isOn: Binding(
                get: { item.wrappedValue.dueDate != nil },
                set: { enabled in
                    item.wrappedValue.dueDate = enabled ? (item.wrappedValue.dueDate ?? Date()) : nil
                }
            ))

            if item.wrappedValue.dueDate != nil {
                DatePicker(
                    "Due Date",
                    selection: Binding(
                        get: { item.wrappedValue.dueDate ?? Date() },
                        set: { item.wrappedValue.dueDate = $0 }
                    ),
                    displayedComponents: [.date]
                )
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var validationSection: some View {
        if let message = viewModel.validationMessage {
            Section {
                Text(message)
                    .foregroundStyle(.red)
            }
        }
    }
}
