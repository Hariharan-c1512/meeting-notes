import SwiftUI

/// The form layout shared by Add Meeting and Edit Meeting.
struct MeetingFormView: View {
    @ObservedObject var viewModel: MeetingFormViewModel

    var body: some View {
        Form {
            Section("Meeting") {
                TextField("Title", text: $viewModel.title)
                DatePicker("Date", selection: $viewModel.date, displayedComponents: [.date, .hourAndMinute])
                Picker("Project", selection: $viewModel.project) {
                    ForEach(Project.allCases) { project in
                        Text(project.rawValue).tag(project)
                    }
                }
            }

            Section {
                TextField("Names separated by commas", text: $viewModel.attendeesText, axis: .vertical)
                    .lineLimit(2...5)
            } header: {
                Text("Attendees")
            }

            Section {
                TextField("One point per line", text: $viewModel.discussionText, axis: .vertical)
                    .lineLimit(3...8)
            } header: {
                Text("Discussion Points")
            }

            Section {
                TextField("One decision per line", text: $viewModel.decisionsText, axis: .vertical)
                    .lineLimit(2...6)
            } header: {
                Text("Decisions")
            }

            Section {
                ForEach($viewModel.actionItems) { $item in
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Action item", text: $item.description)
                        TextField("Owner", text: $item.owner)
                        Picker("Status", selection: $item.status) {
                            ForEach(ActionStatus.allCases) { status in
                                Text(status.rawValue).tag(status)
                            }
                        }
                    }
                    .padding(.vertical, 4)
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

            if let message = viewModel.validationMessage {
                Section {
                    Text(message)
                        .foregroundStyle(.red)
                }
            }
        }
    }
}
