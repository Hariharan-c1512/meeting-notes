import SwiftUI

/// Summary card for one meeting: title, date, project and open action count.
/// Shared by the Dashboard and the Meeting List.
struct MeetingRowView: View {
    let meeting: Meeting

    /// Correct singular or plural wording for the open action item count.
    private var openItemsText: String {
        let count = meeting.openActionItemCount
        return count == 1 ? "1 open action item" : "\(count) open action items"
    }

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
