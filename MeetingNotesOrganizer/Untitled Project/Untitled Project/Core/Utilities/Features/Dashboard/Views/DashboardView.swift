import SwiftUI

/// Home screen: summary cards, the most recent meeting, and a shortcut to add a meeting.
struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @State private var showingAddMeeting = false
    private let store: MeetingStore

    init(store: MeetingStore) {
        self.store = store
        _viewModel = StateObject(wrappedValue: DashboardViewModel(store: store))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    StatCard(title: "Meetings", value: "\(viewModel.totalMeetings)", systemImage: "calendar")
                    StatCard(title: "Open Actions", value: "\(viewModel.openActionItems)", systemImage: "exclamationmark.circle")
                    StatCard(title: "Completed", value: "\(viewModel.completedActionItems)", systemImage: "checkmark.seal")
                }

                Text("Most Recent Meeting")
                    .font(.headline)

                if let recent = viewModel.mostRecentMeeting {
                    NavigationLink(value: recent.id) {
                        MeetingRowView(meeting: recent)
                    }
                    .buttonStyle(.plain)
                } else {
                    EmptyStateView(
                        systemImage: "tray",
                        title: "No meetings yet",
                        message: "Tap + to record your first meeting."
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddMeeting = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddMeeting) {
            AddMeetingView(store: store)
        }
        .navigationDestination(for: UUID.self) { meetingID in
            MeetingDetailView(meetingID: meetingID, store: store)
        }
    }
}
