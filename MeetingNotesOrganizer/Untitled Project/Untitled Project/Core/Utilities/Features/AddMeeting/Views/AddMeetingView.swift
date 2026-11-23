import SwiftUI

/// Sheet for recording a new meeting.
struct AddMeetingView: View {
    @StateObject private var viewModel: MeetingFormViewModel
    @Environment(\.dismiss) private var dismiss

    init(store: MeetingStore) {
        _viewModel = StateObject(wrappedValue: MeetingFormViewModel(store: store))
    }

    var body: some View {
        NavigationStack {
            MeetingFormView(viewModel: viewModel)
                .navigationTitle("New Meeting")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
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
