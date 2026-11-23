import SwiftUI

/// App entry point. Creates the app-wide objects once and injects them into the view tree.
@main
struct MeetingNotesOrganizerApp: App {
    @StateObject private var meetingStore = MeetingStore()
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(meetingStore)
                .environmentObject(authViewModel)
        }
    }
}
