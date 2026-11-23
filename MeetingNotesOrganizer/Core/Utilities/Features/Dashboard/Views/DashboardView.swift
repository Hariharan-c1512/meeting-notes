import SwiftUI

// MARK: - Dashboard View

/// Home screen: summary metric cards, data safety notices, the most recent meeting, and quick actions.
struct DashboardView: View {
    // MARK: - Environment & State

    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var viewModel: DashboardViewModel
    @State private var showingAddMeeting = false
    private let store: MeetingStore

    // MARK: - Initialization

    /// Initializes DashboardView with the shared MeetingStore.
    /// - Parameter store: Data store providing meeting records.
    init(store: MeetingStore) {
        self.store = store
        _viewModel = StateObject(wrappedValue: DashboardViewModel(store: store))
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let notice = viewModel.dataRecoveryNotice {
                    recoveryNoticeCard(notice)
                }

                statsGrid

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
        .inlineNavigationBarTitle()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Log Out") {
                    authViewModel.logOut()
                }
            }

            ToolbarItem(placement: .trailingBarItem) {
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

    // MARK: - Subviews

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(title: "Meetings", value: "\(viewModel.totalMeetings)", systemImage: "calendar")
            StatCard(title: "Open Actions", value: "\(viewModel.openActionItems)", systemImage: "exclamationmark.circle")
            StatCard(title: "Completed", value: "\(viewModel.completedActionItems)", systemImage: "checkmark.seal")
            StatCard(title: "Overdue", value: "\(viewModel.overdueActionItems)", systemImage: "clock.badge.exclamationmark")
        }
    }

    private func recoveryNoticeCard(_ notice: String) -> some View {
        CardView {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Data Recovery Notice")
                        .font(.subheadline.bold())

                    Text(notice)
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    Button("Dismiss") {
                        viewModel.dismissRecoveryNotice()
                    }
                    .font(.footnote.weight(.semibold))
                    .buttonStyle(.bordered)
                    .padding(.top, 4)
                }
            }
        }
    }
}
