import Foundation
import LocalAuthentication

// MARK: - Biometric Result

/// Outcome of a biometric authentication attempt.
enum BiometricResult {
    case success
    /// Biometrics cannot be evaluated on this device (e.g. Not enrolled or unsupported hardware).
    case unavailable(String)
    /// The user cancelled or the biometric match failed.
    case failed(String)
}

// MARK: - Biometric Authenticating Protocol

/// Abstraction allowing ViewModel independence from LocalAuthentication framework for testability.
protocol BiometricAuthenticating {
    /// Attempts biometric authentication with a localized reason string.
    func authenticate(reason: String) async -> BiometricResult
}

// MARK: - Biometric Service

/// Wraps LAContext to verify biometric authentication availability and evaluate policies.
struct BiometricService: BiometricAuthenticating {
    // MARK: - Authentication Method

    func authenticate(reason: String) async -> BiometricResult {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .unavailable(error?.localizedDescription ?? "Face ID is not available on this device.")
        }

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            return success ? .success : .failed("Face ID did not match.")
        } catch {
            return .failed(error.localizedDescription)
        }
    }
}
