import Foundation

// MARK: - Recurrence Interval

/// Defines recurrence cadence options for periodic meetings.
enum RecurrenceInterval: String, Codable, CaseIterable, Identifiable {
    case none = "None"
    case weekly = "Weekly"
    case monthly = "Monthly"

    // MARK: - Identifiable

    var id: String { rawValue }

    // MARK: - Date Calculation

    /// Computes the subsequent meeting date from a base date based on this interval.
    /// - Parameters:
    ///   - baseDate: The date of the previous meeting.
    ///   - calendar: The calendar used for date component calculation.
    /// - Returns: The calculated future date, or baseDate if none.
    func nextDate(after baseDate: Date, calendar: Calendar = .current) -> Date {
        switch self {
        case .none:
            return baseDate
        case .weekly:
            return calendar.date(byAdding: .weekOfYear, value: 1, to: baseDate) ?? baseDate.addingTimeInterval(86_400 * 7)
        case .monthly:
            return calendar.date(byAdding: .month, value: 1, to: baseDate) ?? baseDate.addingTimeInterval(86_400 * 30)
        }
    }
}
