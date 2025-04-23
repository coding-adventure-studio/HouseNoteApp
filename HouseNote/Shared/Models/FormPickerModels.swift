import Foundation

struct NumberField: Hashable, Identifiable {
    var id: String { label }
    let label: String
    let range: ClosedRange<Int>
    let suffix: String
}

struct PickerState: Identifiable {
    let id = UUID()
    let title: String
    let fields: [NumberField]
    let initialValues: [NumberField: Int]
    let onConfirm: ([NumberField: Int]) -> Void
}

enum ItemFieldType: String, CaseIterable, Identifiable {
    case floorCurrent = "所在樓層"
    case floorTotal = "總樓層"
    case layoutRooms = "房"
    case layoutLivingRooms = "廳"
    case layoutBathrooms = "衛"
    case layoutBalconies = "陽台"
    case elevatorHouseholds = "戶"
    case elevatorLifts = "梯"

    var id: String { rawValue }

    var range: ClosedRange<Int> {
        switch self {
        case .floorCurrent, .floorTotal:
            1 ... 50
        case .layoutRooms, .layoutLivingRooms, .layoutBathrooms, .layoutBalconies:
            0 ... 10
        case .elevatorHouseholds:
            1 ... 10
        case .elevatorLifts:
            1 ... 6
        }
    }

    var suffix: String {
        switch self {
        case .floorCurrent, .floorTotal: "F"
        case .layoutRooms: "房"
        case .layoutLivingRooms: "廳"
        case .layoutBathrooms: "衛"
        case .layoutBalconies: "陽台"
        case .elevatorHouseholds: "戶"
        case .elevatorLifts: "梯"
        }
    }

    var numberField: NumberField {
        NumberField(label: rawValue, range: range, suffix: suffix)
    }
}

extension ItemFieldType {
    static var floorFields: [ItemFieldType] {
        [.floorCurrent, .floorTotal]
    }

    static var layoutFields: [ItemFieldType] {
        [.layoutRooms, .layoutLivingRooms, .layoutBathrooms, .layoutBalconies]
    }

    static var elevatorFields: [ItemFieldType] {
        [.elevatorHouseholds, .elevatorLifts]
    }
}
