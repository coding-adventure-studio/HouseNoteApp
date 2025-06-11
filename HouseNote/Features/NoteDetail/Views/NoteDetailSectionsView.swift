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
    @State private var expandedSections: Set<UUID> = []

    var body: some View {
        ScrollView {
            if viewModel.sectionBindings.isEmpty {
                VStack(alignment: .center, spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text("尚未填寫任何區塊內容")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
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
