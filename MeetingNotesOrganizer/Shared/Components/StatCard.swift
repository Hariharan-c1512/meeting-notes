import SwiftUI

// MARK: - Stat Card View

/// A small summary card showing one metric value with an accompanying title and SF Symbol icon.
struct StatCard: View {
    // MARK: - Properties

    let title: String
    let value: String
    let systemImage: String

    // MARK: - Body

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: systemImage)
                    .foregroundStyle(.tint)
                Text(value)
                    .font(.title2.bold())
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
