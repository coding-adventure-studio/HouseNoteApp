import Foundation

class NotesViewModel: ObservableObject {
    @Published var notes: [NoteData] = []

    func addNote(title: String, sections: [PropertySection]) {
        let newNote = NoteData(title: title, sections: sections)
        notes.append(newNote)
    }
}
