import SwiftUI

// MARK: - Main Tab View

/// Primary tabbed navigation: Dashboard and Meetings list.
struct MainTabView: View {
    // MARK: - Environment

    @EnvironmentObject private var store: MeetingStore

    // MARK: - Body

    var body: some View {
        TabView {
            NavigationStack {
                DashboardView(store: store)
            }
            .tabItem {
                Label("Dashboard", systemImage: "square.grid.2x2")
            }

            NavigationStack {
                MeetingListView(store: store)
            }
            .tabItem {
                Label("Meetings", systemImage: "list.bullet")
            }
        }
    }
}
