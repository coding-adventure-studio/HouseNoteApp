import Foundation

struct Note: Identifiable {
    let id: UUID = .init()
    var title: String
    var date: Date = .init()
    var sections: [PropertySection]
}

extension Note {
    func toProperty() -> Property {
        Property(
            id: id,
            name: title,
            sections: sections
        )
    }
}
