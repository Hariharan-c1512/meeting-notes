import SwiftUI

// MARK: - Section Card View

/// A card with a titled header (icon + title) followed by custom child content.
struct SectionCard<Content: View>: View {
    // MARK: - Properties

    private let title: String
    private let systemImage: String
    private let content: Content

    // MARK: - Initialization

    /// Creates a section card with a header and content builder.
    /// - Parameters:
    ///   - title: Header title text.
    ///   - systemImage: SF Symbol icon name.
    ///   - content: View builder for the section body.
    init(title: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }

    // MARK: - Body

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
