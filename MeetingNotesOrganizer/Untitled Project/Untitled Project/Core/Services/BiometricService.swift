import Foundation
import LocalAuthentication

/// Outcome of a biometric (Face ID / Touch ID) attempt.
enum BiometricResult {
    case success
    /// Biometrics cannot be used on this device (not enrolled, not supported, etc.).
    case unavailable(String)
    /// The user cancelled or the match failed.
    case failed(String)
}

/// Abstraction so the ViewModel does not depend on LocalAuthentication directly (easier to test).
protocol BiometricAuthenticating {
    func authenticate(reason: String) async -> BiometricResult
}

/// Wraps LAContext to check and perform Face ID authentication.
struct BiometricService: BiometricAuthenticating {
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
