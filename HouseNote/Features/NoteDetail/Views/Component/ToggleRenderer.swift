import SwiftUI

struct ToggleRenderer: RowValueRenderer {
    @Binding var item: PropertyItem
    let fieldTemplate: FieldTemplate
    let isEditable: Bool

    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate, isEditable: Bool) {
        _item = item
        self.fieldTemplate = fieldTemplate
        self.isEditable = isEditable
    }

    @ViewBuilder
    var body: some View {
        if case .toggle = fieldTemplate.inputKind {
            if isEditable {
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
                let displayText: String = if case let .number(val) = item.value {
                    (val == 1) ? "✔️" : "❌"
                } else {
                    "（尚未設定）"
                }

                Text(displayText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        } else {
            Text("⚠️ 無效的 toggle 設定")
        }
    }
}
