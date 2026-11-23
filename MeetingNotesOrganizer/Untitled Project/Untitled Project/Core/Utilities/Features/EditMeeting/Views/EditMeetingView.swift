import SwiftUI

/// Sheet for changing an existing meeting (discussion points, decisions, action item owners and status).
struct EditMeetingView: View {
    @StateObject private var viewModel: MeetingFormViewModel
    @Environment(\.dismiss) private var dismiss

    init(store: MeetingStore, meeting: Meeting) {
        _viewModel = StateObject(wrappedValue: MeetingFormViewModel(store: store, meeting: meeting))
    }

    var body: some View {
        NavigationStack {
            MeetingFormView(viewModel: viewModel)
                .navigationTitle("Edit Meeting")
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
