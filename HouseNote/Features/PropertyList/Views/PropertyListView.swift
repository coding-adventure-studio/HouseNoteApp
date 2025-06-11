import SwiftUI

struct PropertyListView: View {
    @ObservedObject var viewModel: NotesViewModel
    @State private var selectedProperty: Property? = nil

    var body: some View {
        NavigationStack {
            List(viewModel.notes) { note in
                Button {
                    selectedProperty = note.toProperty()
                } label: {
                    VStack(alignment: .leading) {
                        Text(note.title)
                            .font(.headline)
                        Text("創建時間：\(note.date.formatted(date: .numeric, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("我的筆記")
            .navigationDestination(isPresented: Binding(
                get: { selectedProperty != nil },
                set: { isActive in if !isActive { selectedProperty = nil } }
            )) {
                if let property = selectedProperty,
                   let note = viewModel.notes.first(where: { $0.id == property.id }) {
                    NoteDetailView(
                        viewModel: NoteDetailViewModel(mode: .edit(note), dependency: NoteDetailDependencyMock()),
                        onSaveSuccess: { updatedProperty in
                            if let idx = viewModel.notes.firstIndex(where: { $0.id == updatedProperty.id }) {
                                viewModel.notes[idx].sections = updatedProperty.sections
                                viewModel.notes[idx].title = updatedProperty.name
                            }
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    PropertyListView(viewModel: NotesViewModel())
}
