import Foundation

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []

    func addNote(title: String, sections: [PropertySection]) {
        let newNote = Note(title: title, sections: sections)
        notes.append(newNote)
    }
}
