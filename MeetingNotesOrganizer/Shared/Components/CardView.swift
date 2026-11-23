import SwiftUI

// MARK: - Card Container View

/// Rounded, padded container used for content cards throughout the application.
struct CardView<Content: View>: View {
    // MARK: - Properties

    private let content: Content

    // MARK: - Initialization

    /// Creates a card containing the given view content.
    /// - Parameter content: A ViewBuilder producing the card body.
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.secondarySystemCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
