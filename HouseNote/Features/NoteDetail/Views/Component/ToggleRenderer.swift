import SwiftUI

struct ToggleRenderer: RowValueRenderer {
    @Binding var item: PropertyItem
    let fieldTemplate: FieldTemplate

    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate) {
        _item = item
        self.fieldTemplate = fieldTemplate
    }

    var body: some View {
        if case .toggle = fieldTemplate.inputKind {
            Toggle("", isOn: Binding(
                get: {
                    if case let .number(val) = item.value {
                        return val == 1
                    }
                    return false
                },
                set: { newValue in
                    item.value = .number(newValue ? 1 : 0)
                }
            ))
            .labelsHidden()
        } else {
            Text("⚠️ 無效的 toggle 設定")
        }
    }
}
