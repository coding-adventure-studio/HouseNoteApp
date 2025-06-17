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
        switch fieldTemplate.inputKind {
        case .textField:
            TextFieldRenderer(item: $item, fieldTemplate: fieldTemplate)

        case .numberField:
            NumberFieldRenderer(item: $item, fieldTemplate: fieldTemplate)

        case .multiPicker:
            MultiPickerRenderer(item: $item, fieldTemplate: fieldTemplate)

        case .tagSelector:
            TagSelectorRenderer(item: $item, fieldTemplate: fieldTemplate)

        case .slider:
            SliderRenderer(item: $item, fieldTemplate: fieldTemplate)

        case .toggle:
            ToggleRenderer(item: $item, fieldTemplate: fieldTemplate)
        }
    }

    @ViewBuilder
    private func trailingAccessoryView() -> some View {
        Group {
            if let image = selectedImage {
                Menu {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Label(Localized.Photo.selectAnother, systemImage: "photo.on.rectangle")
                    }

                    Button(role: .destructive, action: {
                        selectedImage = nil
                    }) {
                        Label(Localized.Common.delete, systemImage: "trash")
                    }
                } label: {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            } else {
                Button(action: {
                    showImagePicker = true
                }) {
                    Image(systemName: "camera")
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker { image in
                selectedImage = image
            }
        }
    }
}

// MARK: - Helper Extensions

extension Dictionary {
    func mapKeys<T>(_ transform: (Key) -> T) -> [T: Value] where T: Hashable {
        [T: Value](uniqueKeysWithValues: map { (transform($0.key), $0.value) })
    }
}

extension PickerState {
    static func fromFields(
        _ fields: [NumberField],
        title: String,
        initialValues: [String: Int],
        onConfirm: @escaping ([String: Int]) -> Void
    ) -> PickerState {
        let values: [NumberField: Int] = Dictionary(uniqueKeysWithValues: fields.map {
            ($0, initialValues[$0.label] ?? 0)
        })

        return PickerState(
            title: title,
            fields: fields,
            initialValues: values,
            onConfirm: { raw in
                onConfirm(raw.mapKeys(\.label))
            }
        )
    }
}
