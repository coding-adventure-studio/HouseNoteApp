import SwiftUI

#Preview {
    NoteDetailView(
        viewModel: NoteDetailViewModel(mode: .create, dependency: NoteDetailDependencyMock())
    )
}

struct NoteDetailView: View {
    @ObservedObject var viewModel: NoteDetailViewModel
    @State private var editingTitle = false
    var onSaveSuccess: ((Property) -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var isSaving = false

    var body: some View {
        NavigationView {
            ZStack {
                NoteDetailContentView(viewModel: viewModel, editingTitle: $editingTitle)
                    .navigationBarItems(
                        leading: BackButton(action: viewModel.dismissView),
                        trailing: HStack {
                            LockButton(action: viewModel.lockProperty)
                            SaveButton(action: {
                                isSaving = true
                                viewModel.saveProperty()
                            })
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
                if isSaving {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView("儲存中...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
                        .shadow(radius: 10)
                }
            }
        }
        .onChange(of: viewModel.saveSuccess) { newValue in
            if newValue {
                isSaving = false
                showSuccessAlert = true
            }
        }
        .onChange(of: viewModel.saveError) { newValue in
            if newValue {
                isSaving = false
                showErrorAlert = true
            }
        }
        .alert("儲存成功", isPresented: $showSuccessAlert) {
            Button("確定") {
                onSaveSuccess?(viewModel.property)
                viewModel.saveSuccess = false
                dismiss()
            }
        }
        .alert("儲存失敗，請稍後再試", isPresented: $showErrorAlert) {
            Button("確定") {
                viewModel.saveError = false
            }
        }
    }
}
