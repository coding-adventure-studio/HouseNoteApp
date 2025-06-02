import Foundation

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []

    func addNote(title: String, content: String, sections: [PropertySection]) {
        let newNote = Note(title: title, content: content, sections: sections)
        notes.append(newNote)
    }
}
