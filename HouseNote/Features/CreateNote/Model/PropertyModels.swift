import Foundation
import SwiftUICore

// MARK: - Section & Field Template Definitions

enum NoteSectionType: String, CaseIterable, Identifiable {
    case basicInfo, parking, community

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .basicInfo: "基本資訊"
        case .parking: "車位資訊"
        case .community: "社區資訊"
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
            FieldTemplate(type: .address, label: "地址", inputKind: .textField, defaultValue: .text("")),
            FieldTemplate(type: .floor, label: "樓層", inputKind: .multiPicker(title: "樓層資訊", fields: ItemType.floorFieldLabels), defaultValue: .multi(["所在樓層": 0, "總樓層": 0])),
            FieldTemplate(type: .age, label: "屋齡", inputKind: .numberField, defaultValue: .number(0)),
            FieldTemplate(type: .layout, label: "格局", inputKind: .multiPicker(title: "格局", fields: ItemType.layoutFieldLabels), defaultValue: .multi(["房": 0, "廳": 0, "衛": 0, "陽台": 0])),
            FieldTemplate(type: .brand, label: "建商品牌", inputKind: .textField, defaultValue: .text("")),
            FieldTemplate(type: .price, label: "開價", inputKind: .numberField, defaultValue: .number(0)),
            FieldTemplate(type: .marketPrice, label: "實價登錄", inputKind: .numberField, defaultValue: .number(0))
        ]
    ),
    SectionTemplate(
        type: .parking,
        fields: [
            FieldTemplate(type: .parkingLocation, label: "車位位置", inputKind: .textField, defaultValue: .text("")),
            FieldTemplate(type: .parkingType, label: "車位型態", inputKind: .textField, defaultValue: .text("")),
            FieldTemplate(type: .chargingAvailable, label: "充電設施", inputKind: .numberField, defaultValue: .number(0))
        ]
    ),
    SectionTemplate(
        type: .community,
        fields: [
            FieldTemplate(type: .managementFee, label: "管理費", inputKind: .textField, defaultValue: .text("")),
            FieldTemplate(type: .sharedFacilities, label: "公設", inputKind: .tagSelector(category: .publicFacility), defaultValue: .tagSelector(TagSelection.empty(category: .publicFacility)))
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
        case .managementFee: "管理費"
        case .sharedFacilities: "公設"
        }
    }

    var displayFormatter: (ItemValue) -> String {
        switch self {
        case .floor:
            { value in
                guard case let .multi(dict) = value else { return "❓" }
                let current = dict["所在樓層"] ?? 0
                let total = dict["總樓層"] ?? 0
                return "\(current)F / \(total)F"
            }
        case .layout:
            { value in
                guard case let .multi(dict) = value else { return "❓" }
                let room = dict["房"] ?? 0
                let living = dict["廳"] ?? 0
                let bath = dict["衛"] ?? 0
                let balcony = dict["陽台"] ?? 0
                return "\(room)房 \(living)廳 \(bath)衛 \(balcony)陽台"
            }
        default:
            { value in value.displayText }
        }
    }
}

extension ItemType {
    static var layoutFieldLabels: [String] {
        ["房", "廳", "衛", "陽台"]
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
            value.isEmpty ? "尚未填寫" : value
        case let .number(n):
            "\(n)"
        case let .multi(values):
            values.map { "\($0.key): \($0.value)" }.joined(separator: " ")
        case let .tagSelector(selection):
            selection.selectedTags.isEmpty ? "尚未選擇" : selection.selectedTags.joined(separator: ", ")
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
        case .publicFacility: "公設項目"
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
