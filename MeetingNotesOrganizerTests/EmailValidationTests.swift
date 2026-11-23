import XCTest
@testable import MeetingNotesOrganizer

// MARK: - Email Validation Tests

/// Unit test suite verifying email format validation rules.
final class EmailValidationTests: XCTestCase {
    // MARK: - Test Cases

    /// Verifies that valid email patterns are accepted.
    func testValidEmailAddresses() {
        let validEmails = [
            "user@example.com",
            "first.last@company.org",
            "engineer+work@domain.co.uk",
            "dev_123@sub.domain.io"
        ]

        for email in validEmails {
            XCTAssertTrue(Validators.isValidEmail(email), "Expected '\(email)' to be valid.")
        }
    }

    /// Verifies that malformed or incomplete email strings are rejected.
    func testInvalidEmailAddresses() {
        let invalidEmails = [
            "",
            "   ",
            "notanemail",
            "@missinguser.com",
            "user@.com",
            "user@domain",
            "user@domain.",
            "user name@domain.com"
        ]

        for email in invalidEmails {
            XCTAssertFalse(Validators.isValidEmail(email), "Expected '\(email)' to be invalid.")
        }
    }
}
