import Foundation

// MARK: - Input Validators

/// Reusable input validation rules across the application.
enum Validators {
    // MARK: - Constants

    private static let emailPattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

    // MARK: - Validation Methods

    /// Checks whether the provided text conforms to standard email address formatting.
    /// - Parameter email: The candidate email string.
    /// - Returns: True if valid; false otherwise.
    static func isValidEmail(_ email: String) -> Bool {
        email.trimmed.range(of: emailPattern, options: .regularExpression) != nil
    }
}
