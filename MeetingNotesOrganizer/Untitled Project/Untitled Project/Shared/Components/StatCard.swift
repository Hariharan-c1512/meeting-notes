import SwiftUI

/// A small card showing one number with a title and icon (used on the Dashboard).
struct StatCard: View {
    let title: String
    let value: String
    let systemImage: String

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
