import Combine
import Foundation

/// Controls launch authentication: Face ID first, manual login as the fallback.
@MainActor
final class AuthViewModel: ObservableObject {
    @Published private(set) var isAuthenticated = false
    @Published private(set) var isBiometricFallbackVisible = false
    @Published private(set) var errorMessage: String?
    @Published var email = ""
    @Published var password = ""

    private let biometricService: BiometricAuthenticating
    private let localAuthService: LocalAuthService

    init(
        biometricService: BiometricAuthenticating = BiometricService(),
        localAuthService: LocalAuthService = LocalAuthService()
    ) {
        self.biometricService = biometricService
        self.localAuthService = localAuthService
    }

    /// Runs Face ID. On success the app opens; otherwise the manual login form is shown.
    func authenticateAtLaunch() async {
        guard !isAuthenticated else { return }
        errorMessage = nil

        switch await biometricService.authenticate(reason: "Unlock your meeting notes") {
        case .success:
            isAuthenticated = true
        case .unavailable(let message), .failed(let message):
            errorMessage = message
            isBiometricFallbackVisible = true
        }
    }

    /// Validates the manual form, then signs in with the local account.
    func loginWithCredentials() {
        if let validationError = validate() {
            errorMessage = validationError
            return
        }

        switch localAuthService.signIn(email: email, password: password) {
        case .success:
            errorMessage = nil
            isAuthenticated = true
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }

    /// Returns a message for the first failed rule, or nil when the input is valid.
    private func validate() -> String? {
        if email.trimmed.isEmpty || password.isEmpty {
            return "Email and password are required."
        }
        if !Validators.isValidEmail(email) {
            return "Enter a valid email address, for example name@company.com."
        }
        if password.count < 6 {
            return "Password must be at least 6 characters."
        }
        return nil
    }
}
