import Foundation

/// Reusable input validation rules.
enum Validators {
    private static let emailPattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

    /// True when the text looks like a valid email address (for example, name@company.com).
    static func isValidEmail(_ email: String) -> Bool {
        email.trimmed.range(of: emailPattern, options: .regularExpression) != nil
    }
}
