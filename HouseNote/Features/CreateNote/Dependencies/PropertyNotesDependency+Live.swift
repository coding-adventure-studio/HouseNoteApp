import Foundation

enum EditNoteError: Error {
    case saveFailed
    case uploadFailed
    case invalidData(reason: String)
}

protocol EditNoteDependency {
    func fetchInitialTemplate() -> Property
    func saveLocally(_ property: Property) async throws
    func upload(_ property: Property) async throws
}

struct EditNoteDependencyMock: EditNoteDependency {
    func fetchInitialTemplate() -> Property {
        let sections = allSectionTemplates.map { template in
            PropertySection(
                id: UUID(),
                type: template.type,
                items: template.fields.enumerated().map { idx, field in
                    PropertyItem.make(type: field.type, value: field.defaultValue, order: idx)
                },
                order: 0
            )
        }
        return Property(id: UUID(), name: Localized.UI.newNote, sections: sections)
    }

    func saveLocally(_ property: Property) async throws {
        guard property.sections.count > 0 else {
            throw EditNoteError.invalidData(reason: "Property must have at least one section")
        }
        print("📦 儲存成功：\(property.name)")
    }

    func upload(_ property: Property) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}
