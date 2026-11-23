import SwiftUI

/// Main navigation: Dashboard (home) and Meetings. Each tab has its own navigation stack.
struct MainTabView: View {
    @EnvironmentObject private var store: MeetingStore

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
