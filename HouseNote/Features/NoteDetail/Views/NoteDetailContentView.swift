import SwiftUI

struct NoteDetailContentView: View {
    @ObservedObject var viewModel: NoteDetailViewModel
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
                NoteDetailSectionsView(viewModel: viewModel)
            }
            .padding(.horizontal, 20)
            .background(Color.themeBackground)
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

#Preview {
    NoteDetailContentView(
        viewModel: NoteDetailViewModel(
            mode: .create,
            dependency: NoteDetailDependencyMock()
        ),
        editingTitle: .constant(true)
    )
}
