import Foundation
import SwiftUI
import SwiftUICore

// MARK: - Section & Field Template Definitions

enum NoteSectionType: String, CaseIterable, Identifiable {
    case basicInfo
    case residentInfo
    case interiorCondition
    case parking
    case community
    case environment

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .basicInfo: Localized.Section.basicInfo
        case .residentInfo: Localized.Section.residentInfo
        case .interiorCondition: Localized.Section.interiorCondition
        case .parking: Localized.Section.parking
        case .community: Localized.Section.community
        case .environment: Localized.Section.environment
        }
    }
}

struct FieldTemplate {
    let type: ItemType
    let label: String
    let inputKind: InputKind
    let defaultValue: ItemValue
    let hasPhoto: Bool

    init(
        type: ItemType,
        label: String,
        inputKind: InputKind,
        defaultValue: ItemValue,
        hasPhoto: Bool = false
    ) {
        self.type = type
        self.label = label
        self.inputKind = inputKind
        self.defaultValue = defaultValue
        self.hasPhoto = hasPhoto
    }

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
            case let .slider(value): value != 0
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

extension ItemValue {
    var sliderValueString: String {
        if case let .slider(val) = self {
            return String(Int(val))
        }
        return "-"
    }
}

extension PropertyItem {
    static func make(type: ItemType, value: ItemValue, isStarred: Bool = false, status: ItemStatus = .normal, order: Int = 0) -> PropertyItem {
        PropertyItem(id: UUID(), type: type, value: value, isStarred: isStarred, status: status, order: order)
    }

    static func numberBinding(for item: Binding<PropertyItem>) -> Binding<Int> {
        Binding<Int>(
            get: {
                if case let .number(n) = item.wrappedValue.value { return n }
                return 0
            },
            set: { newValue in
                item.wrappedValue.value = .number(newValue)
            }
        )
    }

    var numberValue: Int {
        if case let .number(n) = value { return n }
        return 0
    }
}

// MARK: - Enum Definitions

enum ItemType {
    case address, floor, age, layout, brand, price, marketPrice
    case totalHouseholds, elevatorHouseholdRatio, householdsPerFloor
    case orientation
    case ventilation
    case parkingLocation, parkingType, parkingTypeDetail, chargingAvailable
    case managementFee, sharedFacilities, tenantCount, vacantCount
    case negativeFacilities
    case note

    var label: String {
        switch self {
        case .address: Localized.Field.Basic.address
        case .floor: Localized.Field.Basic.floor
        case .age: Localized.Field.Basic.age
        case .layout: Localized.Field.Basic.layout
        case .brand: Localized.Field.Basic.brand
        case .price: Localized.Field.Basic.price
        case .marketPrice: Localized.Field.Basic.marketPrice
        case .totalHouseholds: Localized.Form.totalHouseholds
        case .elevatorHouseholdRatio: Localized.Form.elevatorHouseholdRatio
        case .householdsPerFloor: Localized.Form.householdsPerFloor
        case .tenantCount: Localized.Form.tenantCount
        case .vacantCount: Localized.Form.vacantCount
        case .managementFee: Localized.Field.Community.managementFee
        case .sharedFacilities: Localized.Field.Community.sharedFacilities
        case .parkingLocation: Localized.Field.Parking.location
        case .parkingType: Localized.Field.Parking.type
        case .parkingTypeDetail: Localized.Form.parkingTypeDetail
        case .chargingAvailable: Localized.Field.Parking.charging
        case .note: Localized.Field.note
        case .negativeFacilities: Localized.Form.negativeFacilities
        case .orientation: Localized.Form.orientation
        case .ventilation: Localized.Field.Community.ventilation
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
    case slider(Double)
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
        case let .slider(value):
            "\(value)"
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
    case slider(min: Double, max: Double, step: Double)
    case toggle
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
                defaultValue: .text(""),
                hasPhoto: false
            )
        #endif
    }
    return template
}
