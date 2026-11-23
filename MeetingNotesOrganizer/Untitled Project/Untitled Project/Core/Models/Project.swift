import Foundation

/// The project a meeting belongs to. Used for grouping and filtering.
enum Project: String, Codable, CaseIterable, Identifiable {
    case wiproCoE = "Wipro CoE"
    case department = "Department"
    case research = "Research"
    case events = "Events"
    case other = "Other"

    var id: String { rawValue }
}
