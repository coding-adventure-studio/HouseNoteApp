import SwiftUI

struct TagSelectorRenderer: RowValueRenderer {
    @Binding var item: PropertyItem
    let fieldTemplate: FieldTemplate

    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate) {
        _item = item
        self.fieldTemplate = fieldTemplate
    }

    @ViewBuilder
    var body: some View {
        if case let .tagSelector(category) = fieldTemplate.inputKind {
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
            Text("⚠️ 無效的 category 設定")
        }
    }
}
