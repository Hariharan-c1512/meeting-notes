import SwiftUI

// MARK: - Meeting List View

/// Scrollable list of meetings ordered by date, with search, project filter, and swipe-to-delete.
struct MeetingListView: View {
    // MARK: - Properties & State

    @StateObject private var viewModel: MeetingListViewModel
    @State private var showingAddMeeting = false
    private let store: MeetingStore

    // MARK: - Initialization

    /// Initializes MeetingListView with the shared MeetingStore.
    /// - Parameter store: Data store providing meetings.
    init(store: MeetingStore) {
        self.store = store
        _viewModel = StateObject(wrappedValue: MeetingListViewModel(store: store))
    }

    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.filteredMeetings.isEmpty {
                EmptyStateView(
                    systemImage: "magnifyingglass",
                    title: "No meetings found",
                    message: "Try a different search or project filter."
                )
            } else {
                List {
                    ForEach(viewModel.filteredMeetings) { meeting in
                        NavigationLink(value: meeting.id) {
                            MeetingRowView(meeting: meeting)
                        }
                        .listRowSeparator(.hidden)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.delete(meeting)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Meetings")
        .inlineNavigationBarTitle()
        .searchable(text: $viewModel.searchText, prompt: "Search by title or attendee")
        .toolbar {
            ToolbarItem(placement: .leadingBarItem) {
                projectFilterMenu
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

    private var projectFilterMenu: some View {
        Menu {
            Picker("Project", selection: $viewModel.selectedProject) {
                Text("All Projects").tag(Project?.none)
                ForEach(Project.allCases) { project in
                    Text(project.rawValue).tag(Optional(project))
                }
            }
        } label: {
            Image(
                systemName: viewModel.selectedProject == nil
                    ? "line.3.horizontal.decrease.circle"
                    : "line.3.horizontal.decrease.circle.fill"
            )
        }
    }
}
