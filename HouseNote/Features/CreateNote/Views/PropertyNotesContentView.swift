import SwiftUI

struct PropertyNotesContentView: View {
    @ObservedObject var viewModel: PropertyNotesViewModel
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
                PropertySectionsView(viewModel: viewModel)
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
    PropertyNotesContentView(
        viewModel: PropertyNotesViewModel(dependency: PropertyNotesDependencyMock()),
        editingTitle: .constant(true)
    )
}
