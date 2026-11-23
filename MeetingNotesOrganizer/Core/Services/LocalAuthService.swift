import CryptoKit
import Foundation
import Security

// MARK: - Local Authentication Error

/// Errors returned by the local (manual) login flow.
enum LocalAuthError: LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Email or password is incorrect."
        }
    }
}

// MARK: - Local Authentication Service

/// Secure manual authentication service using Keychain storage.
/// The first successful login securely stores the normalized email and SHA-256 password hash in the Keychain.
struct LocalAuthService {
    // MARK: - Properties

    private let service: String
    private let emailAccountKey = "auth.email"
    private let passwordHashAccountKey = "auth.passwordHash"

    // MARK: - Initialization

    /// Creates a LocalAuthService with the specified Keychain service identifier.
    /// - Parameter service: The Keychain service domain identifier.
    init(service: String = "com.example.MeetingNotesOrganizer.auth") {
        self.service = service
    }

    // MARK: - Authentication Methods

    /// Attempts to sign in with the provided email and password.
    /// If no credentials have been saved yet, saves them as the local account.
    /// - Parameters:
    ///   - email: The user's entered email.
    ///   - password: The user's entered password.
    /// - Returns: A Result indicating success or LocalAuthError.
    func signIn(email: String, password: String) -> Result<Void, LocalAuthError> {
        let normalizedEmail = email.trimmed.lowercased()
        let passwordHash = Self.hash(password)

        let storedEmail = readKeychain(account: emailAccountKey)
        let storedHash = readKeychain(account: passwordHashAccountKey)

        if let storedEmail = storedEmail, let storedHash = storedHash {
            return (storedEmail == normalizedEmail && storedHash == passwordHash)
                ? .success(())
                : .failure(.invalidCredentials)
        }

        // First-time setup: persist these credentials as the local account
        saveKeychain(account: emailAccountKey, value: normalizedEmail)
        saveKeychain(account: passwordHashAccountKey, value: passwordHash)
        return .success(())
    }

    /// Clears any saved login credentials from the Keychain.
    func resetAccount() {
        deleteKeychain(account: emailAccountKey)
        deleteKeychain(account: passwordHashAccountKey)
    }

    // MARK: - Hashing Helper

    /// Computes a hexadecimal SHA-256 digest of the provided text string.
    /// - Parameter text: The plain text to hash.
    /// - Returns: A hex-encoded SHA-256 string.
    static func hash(_ text: String) -> String {
        let digest = SHA256.hash(data: Data(text.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    // MARK: - Keychain Operations

    /// Saves a string value to the Keychain with device-only unlocked accessibility.
    private func saveKeychain(account: String, value: String) {
        deleteKeychain(account: account)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: Data(value.utf8),
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        SecItemAdd(query as CFDictionary, nil)
    }

    /// Reads a string value for the given account key from the Keychain.
    private func readKeychain(account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let result = String(data: data, encoding: .utf8) else {
            return nil
        }
        return result
    }

    /// Deletes a Keychain entry for the given account key.
    private func deleteKeychain(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }
}
