import SwiftUI

struct EditNoteContentView: View {
    @ObservedObject var viewModel: EditNoteViewModel
    @Binding var editingTitle: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HeaderControlsView(
                    showStarredOnly: $viewModel.showStarredOnly,
                    advantageCount: viewModel.viewData.advantageCount,
                    disadvantageCount: viewModel.viewData.disadvantageCount,
                    totalCount: viewModel.viewData.totalCount
                )
                PhotoSectionView(onAddPhoto: viewModel.addPhoto)
                EditNoteSectionsView(viewModel: viewModel)
            }
            .padding(.horizontal, 20)
            .background(Color(.systemGroupedBackground))
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

#Preview {
    EditNoteContentView(
        viewModel: EditNoteViewModel(dependency: EditNoteDependencyMock()),
        editingTitle: .constant(true)
    )
}
