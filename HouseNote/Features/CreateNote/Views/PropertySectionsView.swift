import SwiftUI

#Preview {
    PropertySectionsView(viewModel: PropertyNotesViewModel(property: mockProperty))
}

struct PropertySectionsView: View {
    @ObservedObject var viewModel: PropertyNotesViewModel

    var body: some View {
        ForEach(viewModel.filteredSections) { section in
            SectionCardView(section: section, viewModel: viewModel)
        }
    }
}

struct PropertySectionView: View {
    let section: PropertySection
    @ObservedObject var viewModel: PropertyNotesViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(section.type.title)
                .font(.headline)

            ForEach(section.items) { item in
                PropertyItemRowView(
                    item: item,
                    toggleStar: { viewModel.toggleStar(for: item.id) },
                    toggleStatus: { viewModel.toggleStatus(for: item.id) },
                    updateValue: { value in
                        viewModel.updateValue(for: item.id, value: value)
                    }
                )
            }
        }
    }
}
