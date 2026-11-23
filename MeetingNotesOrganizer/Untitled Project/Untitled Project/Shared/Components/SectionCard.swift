import SwiftUI

/// A card with a titled header (icon + text) followed by custom content.
struct SectionCard<Content: View>: View {
    private let title: String
    private let systemImage: String
    private let content: Content

    init(title: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 10) {
                Label(title, systemImage: systemImage)
                    .font(.headline)
                content
            }
        }
    }
}
