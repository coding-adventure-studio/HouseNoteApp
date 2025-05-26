import Foundation

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []

    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content)
        notes.append(newNote)
    }
}
