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

extension PickerState {
    static func fromFields(
        _ fields: [NumberField],
        title: String,
        initialValues: [String: Int],
        onConfirm: @escaping ([String: Int]) -> Void
    ) -> PickerState {
        let values: [NumberField: Int] = Dictionary(uniqueKeysWithValues: fields.map {
            ($0, initialValues[$0.label] ?? 0)
        })

        return PickerState(
            title: title,
            fields: fields,
            initialValues: values,
            onConfirm: { raw in
                onConfirm(raw.mapKeys(\.label))
            }
        )
    }
}

// MARK: - Helper Extensions

extension Dictionary {
    func mapKeys<T>(_ transform: (Key) -> T) -> [T: Value] where T: Hashable {
        [T: Value](uniqueKeysWithValues: map { (transform($0.key), $0.value) })
    }
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
    case age = "form_age"
    case totalHouseholds = "form_total_households"
    case elevatorHouseholdRatio = "form_elevator_household_ratio"
    case householdsPerFloor = "form_households_per_floor"
    case orientation = "form_orientation"
    case parkingLocation = "form_parking_location"
    case parkingTypeDetail = "form_parking_type_detail"
    case tenantCount = "form_tenant_count"
    case vacantCount = "form_vacant_count"
    case negativeFacilities = "form_negative_facilities"

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
        case .age: Localized.Form.age
        case .totalHouseholds: Localized.Form.totalHouseholds
        case .elevatorHouseholdRatio: Localized.Form.elevatorHouseholdRatio
        case .householdsPerFloor: Localized.Form.householdsPerFloor
        case .orientation: Localized.Form.orientation
        case .parkingLocation: Localized.Form.parkingLocation
        case .parkingTypeDetail: Localized.Form.parkingTypeDetail
        case .tenantCount: Localized.Form.tenantCount
        case .vacantCount: Localized.Form.vacantCount
        case .negativeFacilities: Localized.Form.negativeFacilities
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
        case .age, .totalHouseholds, .elevatorHouseholdRatio, .householdsPerFloor, .orientation, .parkingLocation, .parkingTypeDetail, .tenantCount, .vacantCount, .negativeFacilities:
            0 ... 100
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
        case .age: Localized.Form.age
        case .totalHouseholds: Localized.Form.totalHouseholds
        case .elevatorHouseholdRatio: Localized.Form.elevatorHouseholdRatio
        case .householdsPerFloor: Localized.Form.householdsPerFloor
        case .orientation: Localized.Form.orientation
        case .parkingLocation: Localized.Form.parkingLocation
        case .parkingTypeDetail: Localized.Form.parkingTypeDetail
        case .tenantCount: Localized.Form.tenantCount
        case .vacantCount: Localized.Form.vacantCount
        case .negativeFacilities: Localized.Form.negativeFacilities
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
