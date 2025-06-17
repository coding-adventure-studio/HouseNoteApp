import SwiftUI

struct TagSelectorRenderer: RowValueRenderer {
    @Binding var item: PropertyItem
    let fieldTemplate: FieldTemplate
    let isEditable: Bool

    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate, isEditable: Bool) {
        _item = item
        self.fieldTemplate = fieldTemplate
        self.isEditable = isEditable
    }

    var body: some View {
        if case let .tagSelector(category) = fieldTemplate.inputKind {
            if isEditable {
                TagSelectorView(
                    options: category.options,
                    selectedTags: Binding(
                        get: {
                            if case let .tagSelector(selection) = item.value {
                                return selection.selectedTags
                            }
                            return []
                        },
                        set: { newTags in
                            item.value = .tagSelector(TagSelection(category: category, selectedTags: newTags))
                        }
                    )
                )
            } else {
                if case let .tagSelector(selection) = item.value {
                    Text(selection.selectedTags.isEmpty ? "（尚未選擇）" : selection.selectedTags.joined(separator: "、"))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        } else {
            Text("⚠️ 無效的 category 設定")
        }
    }
}
