import SwiftUI

/// Chooses between the login screen and the main app based on authentication state.
struct RootView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

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
