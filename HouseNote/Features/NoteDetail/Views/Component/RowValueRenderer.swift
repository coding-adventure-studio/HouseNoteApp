import SwiftUI

protocol RowValueRenderer: View {
    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate, isEditable: Bool)
}

enum RendererFactory {
    @ViewBuilder
    static func make(inputKind: InputKind, item: Binding<PropertyItem>, fieldTemplate: FieldTemplate, isEditable: Bool) -> some View {
        switch inputKind {
        case .textField:
            TextFieldRenderer(item: item, fieldTemplate: fieldTemplate, isEditable: isEditable)
        case .numberField:
            NumberFieldRenderer(item: item, fieldTemplate: fieldTemplate, isEditable: isEditable)
        case .multiPicker:
            MultiPickerRenderer(item: item, fieldTemplate: fieldTemplate, isEditable: isEditable)
        case .tagSelector:
            TagSelectorRenderer(item: item, fieldTemplate: fieldTemplate, isEditable: isEditable)
        case .slider:
            SliderRenderer(item: item, fieldTemplate: fieldTemplate, isEditable: isEditable)
        case .toggle:
            ToggleRenderer(item: item, fieldTemplate: fieldTemplate, isEditable: isEditable)
        default:
            Text("⚠️ 尚未實作的 inputKind")
        }
    }
}
