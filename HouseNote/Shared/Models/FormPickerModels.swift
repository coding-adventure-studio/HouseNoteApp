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
    case floorCurrent
    case floorTotal
    case layoutRooms
    case layoutLivingRooms
    case layoutBathrooms
    case layoutBalconies
    case elevatorHouseholds
    case elevatorLifts

    var id: String { rawValue }

    var localized: String {
        switch self {
        case .floorCurrent: Localized.Form.floorCurrent
        case .floorTotal: Localized.Form.floorTotal
        case .layoutRooms: Localized.Form.layoutRooms
        case .layoutLivingRooms: Localized.Form.layoutLivingRooms
        case .layoutBathrooms: Localized.Form.layoutBathrooms
        case .layoutBalconies: Localized.Form.layoutBalconies
        case .elevatorHouseholds: Localized.Form.elevatorHouseholds
        case .elevatorLifts: Localized.Form.elevatorLifts
        }
    }

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
        case .layoutRooms: Localized.Form.layoutRooms
        case .layoutLivingRooms: Localized.Form.layoutLivingRooms
        case .layoutBathrooms: Localized.Form.layoutBathrooms
        case .layoutBalconies: Localized.Form.layoutBalconies
        case .elevatorHouseholds: Localized.Form.elevatorHouseholds
        case .elevatorLifts: Localized.Form.elevatorLifts
        }
    }

    var numberField: NumberField {
        NumberField(label: localized, range: range, suffix: suffix)
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
