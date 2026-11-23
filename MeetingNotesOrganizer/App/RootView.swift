import SwiftUI

// MARK: - Root View

/// Root routing view: switches between authentication and the main tab experience.
struct RootView: View {
    // MARK: - Environment

    @EnvironmentObject private var authViewModel: AuthViewModel

    // MARK: - Body

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .task {
            await authViewModel.authenticateAtLaunch()
        }
    }
}
