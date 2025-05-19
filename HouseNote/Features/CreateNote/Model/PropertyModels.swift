import Foundation
import SwiftUI
import SwiftUICore

// MARK: - Section & Field Template Definitions

enum NoteSectionType: String, CaseIterable, Identifiable {
    case basicInfo, parking, community

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .basicInfo: Localized.Section.basicInfo
        case .parking: Localized.Section.parking
        case .community: Localized.Section.community
        }
    }
}

struct FieldTemplate {
    let type: ItemType
    let label: String
    let inputKind: InputKind
    let defaultValue: ItemValue

    var displayText: (ItemValue) -> String {
        type.displayFormatter
    }

    func numberField(for label: String) -> NumberField {
        let suffix: String = switch type {
        case .floor:
            "F"
        case .layout:
            ""
        default:
            label
        }
        return NumberField(label: label, range: 0 ... 100, suffix: suffix)
    }
}

struct SectionTemplate {
    let type: NoteSectionType
    let fields: [FieldTemplate]
}

let allSectionTemplates: [SectionTemplate] = [
    SectionTemplate(
        type: .basicInfo,
        fields: [
            FieldTemplate(type: .address, label: Localized.Field.Basic.address, inputKind: .textField, defaultValue: .text("")),
            FieldTemplate(type: .floor, label: Localized.Field.Basic.floor, inputKind: .multiPicker(title: Localized.Field.Basic.floor, fields: ItemType.floorFieldLabels), defaultValue: .multi(["所在樓層": 0, "總樓層": 0])),
            FieldTemplate(type: .age, label: Localized.Field.Basic.age, inputKind: .numberField, defaultValue: .number(0)),
            FieldTemplate(type: .layout, label: Localized.Field.Basic.layout, inputKind: .multiPicker(title: Localized.Field.Basic.layout, fields: ItemType.layoutFieldLabels), defaultValue: .multi(["房": 0, "廳": 0, "衛": 0, "陽台": 0])),
            FieldTemplate(type: .brand, label: Localized.Field.Basic.brand, inputKind: .textField, defaultValue: .text("")),
            FieldTemplate(type: .price, label: Localized.Field.Basic.price, inputKind: .numberField, defaultValue: .number(0)),
            FieldTemplate(type: .marketPrice, label: Localized.Field.Basic.marketPrice, inputKind: .numberField, defaultValue: .number(0))
        ]
    ),
    SectionTemplate(
        type: .parking,
        fields: [
            FieldTemplate(type: .parkingLocation, label: Localized.Field.Parking.location, inputKind: .textField, defaultValue: .text("")),
            FieldTemplate(type: .parkingType, label: Localized.Field.Parking.type, inputKind: .textField, defaultValue: .text("")),
            FieldTemplate(type: .chargingAvailable, label: Localized.Field.Parking.charging, inputKind: .numberField, defaultValue: .number(0))
        ]
    ),
    SectionTemplate(
        type: .community,
        fields: [
            FieldTemplate(type: .managementFee, label: Localized.Field.Community.managementFee, inputKind: .textField, defaultValue: .text("")),
            FieldTemplate(type: .sharedFacilities, label: Localized.Field.Community.sharedFacilities, inputKind: .tagSelector(category: .publicFacility), defaultValue: .tagSelector(TagSelection.empty(category: .publicFacility)))
        ]
    )
]

// MARK: - Property Core Models

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
    let type: NoteSectionType
    var items: [PropertyItem]
    var order: Int

    var completedCount: Int {
        items.filter {
            switch $0.value {
            case let .text(value): !value.isEmpty
            case let .number(value): value != 0
            case let .multi(dict): dict.values.contains { $0 != 0 }
            case let .tagSelector(tags): !tags.isEmpty
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
    var order: Int
}

extension PropertyItem {
    static func make(type: ItemType, value: ItemValue, isStarred: Bool = false, status: ItemStatus = .normal, order: Int = 0) -> PropertyItem {
        PropertyItem(id: UUID(), type: type, value: value, isStarred: isStarred, status: status, order: order)
    }
}

// MARK: - Enum Definitions

enum ItemType {
    case address, floor, age, layout, brand, price, marketPrice
    case parkingLocation, parkingType, chargingAvailable
    case managementFee, sharedFacilities
    var label: String {
        switch self {
        case .address: Localized.Field.Basic.address
        case .floor: Localized.Field.Basic.floor
        case .age: Localized.Field.Basic.age
        case .layout: Localized.Field.Basic.layout
        case .brand: Localized.Field.Basic.brand
        case .price: Localized.Field.Basic.price
        case .marketPrice: Localized.Field.Basic.marketPrice
        case .parkingLocation: Localized.Field.Parking.location
        case .parkingType: Localized.Field.Parking.type
        case .chargingAvailable: Localized.Field.Parking.charging
        case .managementFee: Localized.Field.Community.managementFee
        case .sharedFacilities: Localized.Field.Community.sharedFacilities
        }
    }

    var displayFormatter: (ItemValue) -> String {
        switch self {
        case .floor:
            { value in
                guard case let .multi(dict) = value else { return "❓" }
                let current = dict["所在樓層"] ?? 0
                let total = dict["總樓層"] ?? 0
                return Localized.Field.Floor.info(current: current, total: total)
            }
        case .layout:
            { value in
                guard case let .multi(dict) = value else { return "❓" }
                let room = dict["房"] ?? 0
                let living = dict["廳"] ?? 0
                let bath = dict["衛"] ?? 0
                let balcony = dict["陽台"] ?? 0
                return Localized.Field.Layout.info(room: room, living: living, bath: bath, balcony: balcony)
            }
        default:
            { value in value.displayText }
        }
    }
}

extension ItemType {
    static var layoutFieldLabels: [String] {
        [
            Localized.Field.Layout.room,
            Localized.Field.Layout.livingRoom,
            Localized.Field.Layout.bathroom,
            Localized.Field.Layout.balcony
        ]
    }

    static var floorFieldLabels: [String] {
        ["所在樓層", "總樓層"]
    }
}

struct TagSelection {
    let category: TagSelectorCategory
    let selectedTags: Set<String>

    var isEmpty: Bool {
        selectedTags.isEmpty
    }

    static func empty(category: TagSelectorCategory) -> TagSelection {
        TagSelection(category: category, selectedTags: [])
    }
}

enum ItemValue {
    case text(String)
    case number(Int)
    case multi([String: Int])
    case tagSelector(TagSelection)
}

extension ItemValue {
    var displayText: String {
        switch self {
        case let .text(value):
            value.isEmpty ? Localized.Message.emptyInput : value
        case let .number(n):
            "\(n)"
        case let .multi(values):
            values.map { "\($0.key): \($0.value)" }.joined(separator: " ")
        case let .tagSelector(selection):
            selection.selectedTags.isEmpty ? Localized.Message.emptySelection : selection.selectedTags.joined(separator: ", ")
        }
    }
}

enum TagSelectorCategory {
    case publicFacility
    case badFengShui
    case annoyingFacility
    case leisureFacility

    var displayName: String {
        switch self {
        case .publicFacility: Localized.Field.Community.sharedFacilities
        case .badFengShui: "風水條件"
        case .annoyingFacility: "嫌惡設施"
        case .leisureFacility: "休閒設施"
        }
    }

    var options: [String] {
        switch self {
        case .publicFacility:
            ["游泳池", "健身房", "閱覽室", "交誼廳", "兒童遊戲室"]
        case .badFengShui:
            ["穿堂煞", "壁刀煞", "路沖", "開門見灶"]
        case .annoyingFacility:
            ["墓地", "工廠", "高壓電塔", "夜市", "垃圾場"]
        case .leisureFacility:
            ["公園", "綠地", "河堤", "自行車道", "運動中心"]
        }
    }
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
        case .normal: .advantage
        case .advantage: .disadvantage
        case .disadvantage: .normal
        }
    }
}

enum InputKind {
    case textField
    case numberField
    case multiPicker(title: String, fields: [String])
    case tagSelector(category: TagSelectorCategory)
}

// MARK: - Utilities

func fieldTemplate(for type: ItemType) -> FieldTemplate {
    guard let template = allSectionTemplates
        .flatMap(\.fields)
        .first(where: { $0.type == type }) else {
        #if DEBUG
            fatalError("❌ Missing FieldTemplate for ItemType: \(type)")
        #else
            print("⚠️ Missing FieldTemplate for ItemType: \(type)")
            return FieldTemplate(
                type: type,
                label: type.label,
                inputKind: .textField,
                defaultValue: .text("")
            )
        #endif
    }
    return template
}
