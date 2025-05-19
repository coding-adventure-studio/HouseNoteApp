import Foundation

private func localized(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
}

public enum Localized {
    public enum Common {
        public static var cancel: String { localized("common_cancel") }
        public static var confirm: String { localized("common_confirm") }
        public static var delete: String { localized("common_delete") }
        public static var save: String { localized("common_save") }
        public static var edit: String { localized("common_edit") }
        public static var done: String { localized("common_done") }
    }

    public enum Section {
        public static var basicInfo: String { localized("section_basic_info") }
        public static var parking: String { localized("section_parking") }
        public static var community: String { localized("section_community") }
        public static var residentInfo: String { localized("section_resident_info") }
        public static var interiorCondition: String { localized("section_interior_condition") }
        public static var environment: String { localized("section_environment") }
    }

    public enum Field {
        public enum Basic {
            public static var address: String { localized("field_address") }
            public static var floor: String { localized("field_floor") }
            public static var age: String { localized("field_age") }
            public static var layout: String { localized("field_layout") }
            public static var brand: String { localized("field_brand") }
            public static var price: String { localized("field_price") }
            public static var marketPrice: String { localized("field_market_price") }
        }

        public enum Parking {
            public static var location: String { localized("field_parking_location") }
            public static var type: String { localized("field_parking_type") }
            public static var charging: String { localized("field_charging_facility") }
        }

        public enum Community {
            public static var managementFee: String { localized("field_management_fee") }
            public static var sharedFacilities: String { localized("field_shared_facilities") }
        }

        public enum Layout {
            public static var room: String { localized("layout_room") }
            public static var livingRoom: String { localized("layout_living_room") }
            public static var bathroom: String { localized("layout_bathroom") }
            public static var balcony: String { localized("layout_balcony") }

            public static func info(room: Int, living: Int, bath: Int, balcony: Int) -> String {
                String(format: localized("format_layout_info"), room, living, bath, balcony)
            }
        }

        public enum Floor {
            public static func info(current: Int, total: Int) -> String {
                String(format: localized("format_floor_info"), current, total)
            }
        }
    }

    public enum Message {
        public static var emptyInput: String { localized("msg_empty_input") }
        public static var emptySelection: String { localized("msg_empty_selection") }
    }

    public enum UI {
        public static var propertyName: String { localized("ui_property_name") }
        public static var addPhoto: String { localized("ui_add_photo") }
        public static var newNote: String { localized("ui_new_note") }
    }

    public enum Form {
        public static var floorCurrent: String { localized("form_floor_current") }
        public static var floorTotal: String { localized("form_floor_total") }
        public static var layoutRooms: String { localized("form_layout_rooms") }
        public static var layoutLivingRooms: String { localized("form_layout_living_rooms") }
        public static var layoutBathrooms: String { localized("form_layout_bathrooms") }
        public static var layoutBalconies: String { localized("form_layout_balconies") }
        public static var elevatorHouseholds: String { localized("form_elevator_households") }
        public static var elevatorLifts: String { localized("form_elevator_lifts") }
        public static var age: String { localized("form_age") }
        public static var totalHouseholds: String { localized("form_total_households") }
        public static var elevatorHouseholdRatio: String { localized("form_elevator_household_ratio") }
        public static var householdsPerFloor: String { localized("form_households_per_floor") }
        public static var orientation: String { localized("form_orientation") }
        public static var parkingLocation: String { localized("form_parking_location") }
        public static var parkingTypeDetail: String { localized("form_parking_type_detail") }
        public static var tenantCount: String { localized("form_tenant_count") }
        public static var vacantCount: String { localized("form_vacant_count") }
        public static var negativeFacilities: String { localized("form_negative_facilities") }
    }
}
