import Foundation
import SwiftUICore

// MARK: - Models

struct Property: Identifiable {
    let id: UUID
    var name: String
    var sections: [PropertySection]
}

extension Property {
    func copyWithUpdatedSections(_ newSections: [PropertySection]) -> Property {
        var updated = self
        updated.sections = newSections
        return updated
    }
}

struct PropertySection: Identifiable {
    let id: UUID
    let type: SectionType
    var items: [PropertyItem]
    var order: Int

    var completedCount: Int {
        items.filter {
            switch $0.value {
            case let .text(value): !value.isEmpty
            case let .number(value): value != 0
            case let .floor(floor, _): floor != 0
            case let .layout(layout, _, _, _): layout != 0
            }
        }.count
    }

    var totalCount: Int {
        items.count
    }
}

struct PropertyItem: Identifiable {
    let id: UUID
    let type: ItemType
    var value: ItemValue
    var isStarred: Bool
    var status: ItemStatus
}

// MARK: - Enums

enum SectionType {
    case photos
    case basicInfo
    case parking

    var title: String {
        switch self {
        case .photos: "相片"
        case .basicInfo: "基本資訊"
        case .parking: "車位資訊"
        }
    }
}

enum ItemType {
    case address, floor, age, layout, brand, price, marketPrice
    case parkingLocation, parkingType, chargingAvailable

    var label: String {
        switch self {
        case .address: "地址"
        case .floor: "樓層"
        case .age: "屋齡"
        case .layout: "格局"
        case .brand: "建商品牌"
        case .price: "開價"
        case .marketPrice: "實價登錄"
        case .parkingLocation: "車位位置"
        case .parkingType: "車位型態"
        case .chargingAvailable: "充電設施"
        }
    }
}

enum ItemValue {
    case text(String)
    case floor(current: Int, total: Int)
    case layout(rooms: Int, livingRooms: Int, bathrooms: Int, balconies: Int)
    case number(Int)
}

enum ItemStatus {
    case normal, advantage, disadvantage

    var color: Color {
        switch self {
        case .normal: .gray.opacity(0.3)
        case .advantage: .green
        case .disadvantage: .red
        }
    }

    func next() -> ItemStatus {
        switch self {
        case .normal:
            .advantage
        case .advantage:
            .disadvantage
        case .disadvantage:
            .normal
        }
    }
}
