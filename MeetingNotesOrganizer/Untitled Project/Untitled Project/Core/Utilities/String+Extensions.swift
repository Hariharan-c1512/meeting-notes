import Foundation

extension String {
    /// The string without leading or trailing whitespace and newlines.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Splits the string on the given separators and returns trimmed, non-empty items.
    func splitItems(by separators: CharacterSet) -> [String] {
        components(separatedBy: separators)
            .map(\.trimmed)
            .filter { !$0.isEmpty }
    }
}
