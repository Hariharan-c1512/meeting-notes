import CryptoKit
import Foundation

/// Errors returned by the local (manual) login.
enum LocalAuthError: LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Email or password is incorrect."
        }
    }
}

/// Manual login used when Face ID is unavailable or fails.
/// The first successful login saves the email and a SHA-256 hash of the password on the device.
/// Note: for production apps, store credentials in the Keychain instead of UserDefaults.
struct LocalAuthService {
    private let defaults: UserDefaults
    private let emailKey = "auth.email"
    private let passwordHashKey = "auth.passwordHash"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func signIn(email: String, password: String) -> Result<Void, LocalAuthError> {
        let normalizedEmail = email.trimmed.lowercased()
        let passwordHash = Self.hash(password)

        if let storedEmail = defaults.string(forKey: emailKey),
           let storedHash = defaults.string(forKey: passwordHashKey) {
            return (storedEmail == normalizedEmail && storedHash == passwordHash)
                ? .success(())
                : .failure(.invalidCredentials)
        }

        // First-time setup: these credentials become the local account.
        defaults.set(normalizedEmail, forKey: emailKey)
        defaults.set(passwordHash, forKey: passwordHashKey)
        return .success(())
    }

    static func hash(_ text: String) -> String {
        let digest = SHA256.hash(data: Data(text.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
