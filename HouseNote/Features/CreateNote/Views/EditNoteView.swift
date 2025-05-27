import SwiftUI

#Preview {
    EditNoteView(
        viewModel: EditNoteViewModel(dependency: EditNoteDependencyMock())
    )
}

struct EditNoteView: View {
    @StateObject var viewModel: EditNoteViewModel
    @State private var editingTitle = false
    var onSaveSuccess: ((Property) -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccessAlert = false

    var body: some View {
        NavigationView {
            EditNoteContentView(viewModel: viewModel, editingTitle: $editingTitle)
                .navigationBarItems(
                    leading: BackButton(action: viewModel.dismissView),
                    trailing: HStack {
                        LockButton(action: viewModel.lockProperty)
                        SaveButton(action: viewModel.saveProperty)
                    }
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        EditableNavTitleView(
                            title: $viewModel.property.name,
                            isEditing: $editingTitle
                        )
                    }
                }
        }
        .onChange(of: viewModel.saveSuccess) {
            if viewModel.saveSuccess {
                showSuccessAlert = true
            }
        }
        .alert(Localized.Message.saveSuccess, isPresented: $showSuccessAlert) {
            Button(Localized.Common.confirm) {
                onSaveSuccess?(viewModel.property)
                viewModel.saveSuccess = false
            }
        }
    }
}
