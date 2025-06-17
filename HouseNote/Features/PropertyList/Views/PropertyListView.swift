import SwiftUI

struct PropertyListView: View {
    @ObservedObject var viewModel: NotesViewModel
    @State private var selectedNote: NoteData? = nil

    var body: some View {
        NavigationStack {
            List(viewModel.notes) { note in
                Button {
                    selectedNote = note
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
            .sheet(item: $selectedNote) { note in
                NoteDetailView(
                    viewModel: NoteDetailViewModel(mode: .view(note), dependency: NoteDetailDependencyMock()),
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

#Preview {
    PropertyListView(viewModel: NotesViewModel())
}
