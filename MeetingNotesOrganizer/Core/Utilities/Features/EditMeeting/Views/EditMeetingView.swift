import SwiftUI

// MARK: - Edit Meeting View

/// Modal presentation for updating an existing meeting record.
struct EditMeetingView: View {
    // MARK: - Properties & State

    @StateObject private var viewModel: MeetingFormViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Initialization

    /// Initializes EditMeetingView for the given meeting.
    /// - Parameters:
    ///   - store: The backing data store.
    ///   - meeting: The existing meeting to modify.
    init(store: MeetingStore, meeting: Meeting) {
        _viewModel = StateObject(wrappedValue: MeetingFormViewModel(store: store, meeting: meeting))
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            MeetingFormView(viewModel: viewModel)
                .navigationTitle("Edit Meeting")
                .inlineNavigationBarTitle()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if viewModel.save() {
                                dismiss()
                            }
                        }
                        .fontWeight(.semibold)
                    }
                }
        }
    }
}
