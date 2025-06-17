import SwiftUI

struct NumberFieldRenderer: RowValueRenderer {
    @Binding var item: PropertyItem
    let fieldTemplate: FieldTemplate
    let isEditable: Bool

    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate, isEditable: Bool) {
        _item = item
        self.fieldTemplate = fieldTemplate
        self.isEditable = isEditable
    }

    var body: some View {
        if case .numberField = fieldTemplate.inputKind {
            TextField(
                "請輸入\(fieldTemplate.label)",
                value: PropertyItem.numberBinding(for: $item),
                formatter: NumberFormatter()
            )
            .keyboardType(.numberPad)
            .font(.subheadline)
            .submitLabel(.done)
            .onSubmit {
                hideKeyboard()
            }
        } else {
            Text("⚠️ 無效的 numberField 設定")
        }
    }
}
