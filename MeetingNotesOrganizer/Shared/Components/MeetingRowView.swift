import SwiftUI

// MARK: - Meeting Row View

/// Summary card for one meeting displaying title, date, project, and open action item counts.
struct MeetingRowView: View {
    // MARK: - Properties

    let meeting: Meeting

    // MARK: - Computed Helpers

    /// Formatted text indicating open action item counts with proper pluralization.
    private var openItemsText: String {
        let count = meeting.openActionItemCount
        return count == 1 ? "1 open action item" : "\(count) open action items"
    }

    // MARK: - Body

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                Text(meeting.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Label(meeting.date.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
                Label(meeting.project.rawValue, systemImage: "folder")
                Label(openItemsText, systemImage: "checklist")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
}
