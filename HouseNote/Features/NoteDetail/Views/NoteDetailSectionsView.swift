import SwiftUI

#Preview {
    NoteDetailSectionsView(
        viewModel: NoteDetailViewModel(
            mode: .create,
            dependency: NoteDetailDependencyMock()
        )
    )
}

struct NoteDetailSectionsView: View {
    @ObservedObject var viewModel: NoteDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach($viewModel.property.sections) { $section in
                    SectionCardView(section: $section, viewModel: viewModel)
                }
            }
        }
    }
}
