import SwiftUI

#Preview {
    PropertySectionsView(
        viewModel: PropertyNotesViewModel(dependency: PropertyNotesDependencyMock())
    )
}

struct PropertySectionsView: View {
    @ObservedObject var viewModel: PropertyNotesViewModel
    @State private var expandedSections: Set<UUID> = []

    var body: some View {
        ScrollView {
            ForEach(viewModel.sectionBindings.indices, id: \.self) { index in
                let sectionBinding = viewModel.sectionBindings[index]
                let section = sectionBinding.wrappedValue
                let isExpanded = expandedSections.contains(section.id)

                VStack(alignment: .leading, spacing: 4) {
                    Button {
                        toggleSection(section.id)
                    } label: {
                        HStack {
                            Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            Text(section.type.displayName)
                                .font(.headline)

                            Text("（\(section.completedCount)/\(section.totalCount)）")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())

                    if isExpanded {
                        SectionCardView(section: sectionBinding, viewModel: viewModel)
                    }
                }
                .padding(.bottom, 12)
            }
        }
        .onAppear {
            expandedSections = Set(viewModel.sectionBindings.map(\.wrappedValue.id))
        }
    }

    private func toggleSection(_ id: UUID) {
        if expandedSections.contains(id) {
            expandedSections.remove(id)
        } else {
            expandedSections.insert(id)
        }
    }
}
