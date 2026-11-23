import Foundation

// MARK: - Project Scope

/// The project domain a meeting belongs to. Used for categorization and filtering.
enum Project: String, Codable, CaseIterable, Identifiable {
    case wiproCoE = "Wipro CoE"
    case department = "Department"
    case research = "Research"
    case events = "Events"
    case other = "Other"

    // MARK: - Identifiable

    var id: String { rawValue }
}
