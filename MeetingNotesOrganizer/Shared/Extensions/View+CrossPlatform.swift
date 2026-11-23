import SwiftUI

// MARK: - View Cross-Platform Modifiers

extension View {
    /// Applies inline navigation title display mode on iOS, and standard display mode on other platforms.
    @ViewBuilder
    func inlineNavigationBarTitle() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }

    /// Configures keyboard type and autocapitalization for email fields on platforms that support them.
    @ViewBuilder
    func emailInputConfiguration() -> some View {
        #if os(iOS)
        self
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
        #else
        self
        #endif
    }
}

// MARK: - Toolbar Item Placement Cross-Platform Helpers

extension ToolbarItemPlacement {
    /// Safe cross-platform placement for leading toolbar items.
    static var leadingBarItem: ToolbarItemPlacement {
        #if os(iOS)
        return .navigationBarLeading
        #else
        return .navigation
        #endif
    }

    /// Safe cross-platform placement for trailing toolbar items.
    static var trailingBarItem: ToolbarItemPlacement {
        #if os(iOS)
        return .navigationBarTrailing
        #else
        return .primaryAction
        #endif
    }
}
