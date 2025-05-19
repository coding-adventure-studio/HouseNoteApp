import Foundation
import SwiftUI

// MARK: - All Section Templates

let allSectionTemplates: [SectionTemplate] = [
    basicInfoSection,
    residentInfoSection,
    interiorConditionSection,
    parkingSection,
    communitySection,
    environmentSection
]

// MARK: - Section Templates

let basicInfoSection = SectionTemplate(
    type: .basicInfo,
    fields: [
        FieldTemplate(type: .address, label: Localized.Field.Basic.address, inputKind: .textField, defaultValue: .text("")),
        FieldTemplate(type: .floor, label: Localized.Field.Basic.floor, inputKind: .multiPicker(title: Localized.Field.Basic.floor, fields: ItemType.floorFieldLabels), defaultValue: .multi([Localized.Form.floorCurrent: 0, Localized.Form.floorTotal: 0])),
        FieldTemplate(type: .age, label: Localized.Field.Basic.age, inputKind: .numberField, defaultValue: .number(0)),
        FieldTemplate(type: .layout, label: Localized.Field.Basic.layout, inputKind: .multiPicker(title: Localized.Field.Basic.layout, fields: ItemType.layoutFieldLabels), defaultValue: .multi(["房": 0, "廳": 0, "衛": 0, "陽台": 0])),
        FieldTemplate(type: .brand, label: Localized.Field.Basic.brand, inputKind: .textField, defaultValue: .text("")),
        FieldTemplate(type: .price, label: Localized.Field.Basic.price, inputKind: .numberField, defaultValue: .number(0)),
        FieldTemplate(type: .marketPrice, label: Localized.Field.Basic.marketPrice, inputKind: .numberField, defaultValue: .number(0))
    ]
)

let residentInfoSection = SectionTemplate(
    type: .residentInfo,
    fields: [
        FieldTemplate(type: .totalHouseholds, label: Localized.Form.totalHouseholds, inputKind: .numberField, defaultValue: .number(0)),
        FieldTemplate(type: .elevatorHouseholdRatio, label: Localized.Form.elevatorHouseholdRatio, inputKind: .multiPicker(title: Localized.Form.elevatorHouseholdRatio, fields: [Localized.Form.elevatorLifts, Localized.Form.elevatorHouseholds]), defaultValue: .multi([Localized.Form.elevatorLifts: 0, Localized.Form.elevatorHouseholds: 0])),
        FieldTemplate(type: .householdsPerFloor, label: Localized.Form.householdsPerFloor, inputKind: .numberField, defaultValue: .number(0))
    ]
)

let interiorConditionSection = SectionTemplate(
    type: .interiorCondition,
    fields: [
        FieldTemplate(type: .orientation, label: Localized.Form.orientation, inputKind: .multiPicker(title: Localized.Form.orientation, fields: ["坐", "朝"]), defaultValue: .multi(["坐": 0, "朝": 0]))
    ]
)

let parkingSection = SectionTemplate(
    type: .parking,
    fields: [
        FieldTemplate(type: .parkingLocation, label: Localized.Field.Parking.location, inputKind: .textField, defaultValue: .text("")),
        FieldTemplate(type: .parkingType, label: Localized.Field.Parking.type, inputKind: .textField, defaultValue: .text("")),
        FieldTemplate(type: .parkingTypeDetail, label: Localized.Form.parkingTypeDetail, inputKind: .textField, defaultValue: .text("")),
        FieldTemplate(type: .chargingAvailable, label: Localized.Field.Parking.charging, inputKind: .numberField, defaultValue: .number(0))
    ]
)

let communitySection = SectionTemplate(
    type: .community,
    fields: [
        FieldTemplate(type: .tenantCount, label: Localized.Form.tenantCount, inputKind: .numberField, defaultValue: .number(0)),
        FieldTemplate(type: .vacantCount, label: Localized.Form.vacantCount, inputKind: .numberField, defaultValue: .number(0)),
        FieldTemplate(type: .managementFee, label: Localized.Field.Community.managementFee, inputKind: .textField, defaultValue: .text("")),
        FieldTemplate(type: .sharedFacilities, label: Localized.Field.Community.sharedFacilities, inputKind: .tagSelector(category: .publicFacility), defaultValue: .tagSelector(TagSelection.empty(category: .publicFacility)))
    ]
)

let environmentSection = SectionTemplate(
    type: .environment,
    fields: [
        FieldTemplate(type: .negativeFacilities, label: Localized.Form.negativeFacilities, inputKind: .tagSelector(category: .annoyingFacility), defaultValue: .tagSelector(TagSelection.empty(category: .annoyingFacility)))
    ]
)
