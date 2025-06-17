import SwiftUI

struct MultiPickerRenderer: RowValueRenderer {
    @Binding var item: PropertyItem
    let fieldTemplate: FieldTemplate
    let isEditable: Bool
    @State private var pickerState: PickerState?

    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate, isEditable: Bool) {
        _item = item
        self.fieldTemplate = fieldTemplate
        self.isEditable = isEditable
    }

    var body: some View {
        if isEditable {
            Button {
                let numberFields: [String] = if case let .multiPicker(_, fields) = fieldTemplate.inputKind {
                    fields
                } else {
                    []
                }
                let initialValues: [String: Int] = if case let .multi(dict) = item.value {
                    dict
                } else {
                    [:]
                }

                pickerState = PickerState.fromFields(
                    numberFields.map { fieldTemplate.numberField(for: $0) },
                    title: fieldTemplate.label,
                    initialValues: initialValues
                ) {
                    item.value = .multi($0)
                }
            } label: {
                Text(fieldTemplate.displayText(item.value))
                    .foregroundColor(.blue)
            }
            .sheet(item: $pickerState) { picker in
                MultiFieldNumberPickerView(
                    fields: picker.fields,
                    initialValues: picker.initialValues,
                    title: picker.title,
                    onConfirm: picker.onConfirm
                )
            }
        } else {
            Text(fieldTemplate.displayText(item.value))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
