import SwiftUI

struct TextFieldRenderer: RowValueRenderer {
    @Binding var item: PropertyItem
    let fieldTemplate: FieldTemplate
    let isEditable: Bool

    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate, isEditable: Bool) {
        _item = item
        self.fieldTemplate = fieldTemplate
        self.isEditable = isEditable
    }

    var body: some View {
        HStack(spacing: 8) {
            if case let .text(value) = item.value {
                if isEditable {
                    TextField("請輸入\(fieldTemplate.label)", text: Binding(
                        get: { value },
                        set: { item.value = .text($0) }
                    ))
                    .font(.subheadline)
                    .submitLabel(.done)
                    .onSubmit { hideKeyboard() }
                } else {
                    Text(value.isEmpty ? "（尚未填寫）" : value)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            } else {
                Text("⚠️ 預期是 text，但實際是 \(item.value)")
            }
        }
    }
}
