import SwiftUI

protocol RowValueRenderer: View {
    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate)
}

enum RendererFactory {
    @ViewBuilder
    static func make(inputKind: InputKind, item: Binding<PropertyItem>, fieldTemplate: FieldTemplate) -> some View {
        switch inputKind {
        case .textField:
            TextFieldRenderer(item: item, fieldTemplate: fieldTemplate)
        case .numberField:
            NumberFieldRenderer(item: item, fieldTemplate: fieldTemplate)
        case .multiPicker:
            MultiPickerRenderer(item: item, fieldTemplate: fieldTemplate)
        case .tagSelector:
            TagSelectorRenderer(item: item, fieldTemplate: fieldTemplate)
        case .slider:
            SliderRenderer(item: item, fieldTemplate: fieldTemplate)
        case .toggle:
            ToggleRenderer(item: item, fieldTemplate: fieldTemplate)
        default:
            Text("⚠️ 尚未實作的 inputKind")
        }
    }
}
