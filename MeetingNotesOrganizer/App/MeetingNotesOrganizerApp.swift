import SwiftUI

// MARK: - App Entry Point

/// App entry point. Creates app-wide dependencies once and injects them into the view hierarchy.
@main
struct MeetingNotesOrganizerApp: App {
    // MARK: - App State

    @StateObject private var meetingStore = MeetingStore()
    @StateObject private var authViewModel = AuthViewModel()

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(meetingStore)
                .environmentObject(authViewModel)
        }
    }
}
