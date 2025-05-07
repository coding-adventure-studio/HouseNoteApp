import Foundation

protocol PropertyNotesDependency {
    func fetchInitialTemplate() -> Property
    func saveLocally(_ property: Property)
    func upload(_ property: Property) async throws
}

struct PropertyNotesDependencyMock: PropertyNotesDependency {
    func fetchInitialTemplate() -> Property {
        Property(
            id: UUID(),
            name: "新筆記",
            sections: [
                PropertySection(
                    id: UUID(),
                    type: .basicInfo,
                    items: [
                        .make(type: ItemType.address, value: .text(""), order: 0),
                        .make(type: .floor, value: .multi(["所在樓層": 0, "總樓層": 0]), order: 1),
                        .make(type: .layout, value: .multi(["房": 0, "廳": 0, "衛": 0, "陽台": 0]), order: 2)
                    ], order: 0
                ),
                PropertySection(
                    id: UUID(),
                    type: .parking,
                    items: [
                        .make(type: ItemType.parkingLocation, value: .text(""), order: 0),
                        .make(type: ItemType.parkingType, value: .text(""), order: 1)
                    ],
                    order: 1
                ),
                PropertySection(id: UUID(),
                                type: .community,
                                items: [
                                    .make(type: ItemType.managementFee, value: .text(""), order: 0),
                                    .make(type: ItemType.sharedFacilities, value: .text(""), order: 1),
                                ],
                                order: 2
                               )
            ]
        )
    }

    func saveLocally(_ property: Property) {
        print("📦 儲存成功：\(property.name)")
    }

    func upload(_ property: Property) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}
