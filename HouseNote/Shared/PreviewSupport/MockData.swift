import Foundation

let mockProperty = Property(
    id: UUID(),
    name: "幸福花園",
    sections: [
        PropertySection(
            id: UUID(),
            type: .basicInfo,
            items: [
                PropertyItem(
                    id: UUID(),
                    type: .address,
                    value: .text("台北市信義區信義路五段"),
                    isStarred: false,
                    status: .normal
                ),
                PropertyItem(
                    id: UUID(),
                    type: .floor,
                    value: .floor(current: 8, total: 12),
                    isStarred: true,
                    status: .advantage
                ),
                PropertyItem(
                    id: UUID(),
                    type: .layout,
                    value: .layout(rooms: 3, livingRooms: 2, bathrooms: 2, balconies: 1),
                    isStarred: false,
                    status: .normal
                )
            ],
            order: 1
        ),
        PropertySection(
            id: UUID(),
            type: .parking,
            items: [
                PropertyItem(
                    id: UUID(),
                    type: .parkingType,
                    value: .text("平面車位"),
                    isStarred: false,
                    status: .normal
                )
            ],
            order: 2
        )
    ]
)
