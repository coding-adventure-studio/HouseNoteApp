import SwiftUI

struct SectionCardView: View {
    @Binding var section: PropertySection
    @ObservedObject var viewModel: NoteDetailViewModel

    var body: some View {
        let indexedItems = Array(zip(section.items.indices, $section.items))
        let mode = viewModel.mode

        VStack(alignment: .leading, spacing: 16) {
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
                    Divider().padding(.leading, 30)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
}

struct PropertyItemRowView: View {
    @Binding var item: PropertyItem
    let toggleStar: () -> Void
    let toggleStatus: () -> Void
    let fieldTemplate: FieldTemplate
    let mode: NoteMode

    @State private var pickerState: PickerState?
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        HStack {
            Button(action: toggleStar) {
                Image(systemName: item.isStarred ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }

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

    @ViewBuilder
    private var itemValueEditor: some View {
        RendererFactory.make(
            inputKind: fieldTemplate.inputKind,
            item: $item,
            fieldTemplate: fieldTemplate,
            isEditable: {
                if case .view = mode { return false }
                return true
            }()
        )
    }
}
