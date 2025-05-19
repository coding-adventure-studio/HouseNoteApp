import Foundation

enum PropertyError: Error {
    case saveFailed
    case uploadFailed
    case invalidData(reason: String)
}

protocol PropertyNotesDependency {
    func fetchInitialTemplate() -> Property
    func saveLocally(_ property: Property) async throws
    func upload(_ property: Property) async throws
}

struct PropertyNotesDependencyMock: PropertyNotesDependency {
    func fetchInitialTemplate() -> Property {
        let sections = [
            makeBasicInfoSection(),
            makeParkingSection(),
            makeCommunitySection()
        ]
        return Property(id: UUID(), name: Localized.UI.newNote, sections: sections)
    }

    private func makeBasicInfoSection() -> PropertySection {
        PropertySection(
            id: UUID(),
            type: .basicInfo,
            items: [
                .make(type: ItemType.address, value: .text(""), order: 0),
                .make(type: .floor, value: .multi([Localized.Form.floorCurrent: 0, Localized.Form.floorTotal: 0]), order: 1),
                .make(type: .layout, value: .multi([Localized.Form.layoutRooms: 0, Localized.Form.layoutLivingRooms: 0, Localized.Form.layoutBathrooms: 0, Localized.Form.layoutBalconies: 0]), order: 2)
            ],
            order: 0
        )
    }

    private func makeParkingSection() -> PropertySection {
        PropertySection(
            id: UUID(),
            type: .parking,
            items: [
                .make(type: ItemType.parkingLocation, value: .text(""), order: 0),
                .make(type: ItemType.parkingType, value: .text(""), order: 1)
            ],
            order: 1
        )
    }

    private func makeCommunitySection() -> PropertySection {
        PropertySection(
            id: UUID(),
            type: .community,
            items: [
                .make(type: ItemType.managementFee, value: .text(""), order: 0),
                .make(type: ItemType.sharedFacilities, value: .tagSelector(TagSelection.empty(category: .publicFacility)), order: 1)
            ],
            order: 2
        )
    }

    func saveLocally(_ property: Property) async throws {
        guard property.sections.count > 0 else {
            throw PropertyError.invalidData(reason: "Property must have at least one section")
        }
        print("📦 儲存成功：\(property.name)")
    }

    func upload(_ property: Property) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}
