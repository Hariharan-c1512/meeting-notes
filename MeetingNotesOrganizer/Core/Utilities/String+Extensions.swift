import Foundation

// MARK: - String Utilities

extension String {
    // MARK: - Trimming

    /// The string with leading and trailing whitespace and newlines removed.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Splitting

    /// Splits the string on the given character separators and returns trimmed, non-empty items.
    /// - Parameter separators: Character set defining delimiters.
    /// - Returns: An array of non-empty string components.
    func splitItems(by separators: CharacterSet) -> [String] {
        components(separatedBy: separators)
            .map(\.trimmed)
            .filter { !$0.isEmpty }
    }
}
