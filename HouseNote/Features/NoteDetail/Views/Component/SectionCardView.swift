import SwiftUI

struct SectionCardView: View {
    @Binding var section: PropertySection
    @ObservedObject var viewModel: NoteDetailViewModel
    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: isExpanded ? 12 : 0) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(section.type.displayName)
                        .font(.headline)
                        .foregroundColor(.themePrimary)

                    Spacer()

                    Text("(\(section.completedCount)/\(section.totalCount))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                }
                .padding(.bottom, 8)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .offset(y: 4),
                    alignment: .bottom
                )
            }

            if isExpanded {
                contentView
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private var contentView: some View {
        let indexedItems = Array(zip(section.items.indices, $section.items))
        let mode = viewModel.mode

        return VStack(alignment: .leading, spacing: 12) {
            ForEach(indexedItems, id: \.0) { index, itemBinding in
                let itemId = itemBinding.wrappedValue.id
                let itemType = itemBinding.wrappedValue.type

                PropertyItemRowView(
                    item: itemBinding,
                    toggleStar: { viewModel.toggleStar(for: itemId) },
                    toggleStatus: { viewModel.toggleStatus(for: itemId) },
                    fieldTemplate: fieldTemplate(for: itemType),
                    mode: mode
                )
                if index < section.items.count - 1 {
                    Divider()
                        .padding(.leading, 20)
                }
            }
        }
    }
}

struct PropertyItemRowView: View {
    @Binding var item: PropertyItem
    let toggleStar: () -> Void
    let toggleStatus: () -> Void
    let fieldTemplate: FieldTemplate
    let mode: NoteMode

    @State private var pickerState: PickerState?

    var body: some View {
        HStack {
            Button(action: toggleStar) {
                Image(systemName: item.isStarred ? "star.fill" : "star")
                    .foregroundColor(.themePrimary)
            }
            .disabled(isViewMode)

            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(fieldTemplate.label)
                    .font(.headline)
                    .foregroundColor(.black)

                itemValueEditor
            }

            Spacer()

            Circle()
                .fill(item.status.color)
                .frame(width: 10, height: 10)
                .onTapGesture(perform: toggleStatus)
                .opacity(isViewMode ? 0.6 : 1.0)
        }
        .sheet(item: $pickerState) { picker in
            MultiFieldNumberPickerView(
                fields: picker.fields,
                initialValues: picker.initialValues,
                title: picker.title,
                onConfirm: picker.onConfirm
            )
        }
    }

    private var isViewMode: Bool {
        if case .view = mode { return true }
        return false
    }

    @ViewBuilder
    private var itemValueEditor: some View {
        RendererFactory.make(
            inputKind: fieldTemplate.inputKind,
            item: $item,
            fieldTemplate: fieldTemplate,
            isEditable: !isViewMode
        )
    }
}
