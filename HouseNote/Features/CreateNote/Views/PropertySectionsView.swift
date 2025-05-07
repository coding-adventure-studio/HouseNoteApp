import SwiftUI

#Preview {
    PropertySectionsView(
        viewModel: PropertyNotesViewModel(dependency: PropertyNotesDependencyMock())
    )
}

struct PropertySectionsView: View {
    @ObservedObject var viewModel: PropertyNotesViewModel

    var body: some View {
        ForEach(viewModel.sectionBindings.indices, id: \.self) { index in
            SectionCardView(
                section: viewModel.sectionBindings[index],
                viewModel: viewModel
            )
        }
    }
}
