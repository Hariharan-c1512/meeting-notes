import SwiftUI

// MARK: - Add Meeting View

/// Modal presentation for authoring and inserting a new meeting record.
struct AddMeetingView: View {
    // MARK: - Properties & State

    @StateObject private var viewModel: MeetingFormViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Initialization

    /// Initializes AddMeetingView backed by the shared MeetingStore.
    /// - Parameter store: Data store to receive the new meeting.
    init(store: MeetingStore) {
        _viewModel = StateObject(wrappedValue: MeetingFormViewModel(store: store))
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            MeetingFormView(viewModel: viewModel)
                .navigationTitle("New Meeting")
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
