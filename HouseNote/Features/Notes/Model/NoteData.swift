import Foundation

struct NoteData: Identifiable {
    let id: UUID = .init()
    var title: String
    var date: Date = .init()
    var sections: [PropertySection]
}

extension NoteData {
    func toProperty() -> Property {
        Property(
            id: id,
            name: title,
            sections: sections
        )
    }
}
