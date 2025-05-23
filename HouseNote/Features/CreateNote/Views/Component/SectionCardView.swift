import SwiftUI

struct SectionCardView: View {
    @Binding var section: PropertySection
    @ObservedObject var viewModel: PropertyNotesViewModel

    var body: some View {
        let indexedItems = Array(zip(section.items.indices, $section.items))

        VStack(alignment: .leading, spacing: 16) {
            ForEach(indexedItems, id: \.0) { index, itemBinding in
                let itemId = itemBinding.wrappedValue.id
                let itemType = itemBinding.wrappedValue.type

                PropertyItemRowView(
                    item: itemBinding,
                    toggleStar: { viewModel.toggleStar(for: itemId) },
                    toggleStatus: { viewModel.toggleStatus(for: itemId) },
                    fieldTemplate: fieldTemplate(for: itemType)
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
            if case let .text(value) = item.value {
                HStack(spacing: 8) {
                    TextField("請輸入\(fieldTemplate.label)", text: Binding(
                        get: { value },
                        set: { item.value = .text($0) }
                    ))
                    .font(.subheadline)
                    .submitLabel(.done)
                    .onSubmit {
                        hideKeyboard()
                    }
                    if fieldTemplate.hasPhoto {
                        trailingAccessoryView()
                    }
                }
            } else {
                Text("⚠️ 預期是 text，但實際是 \(item.value)")
            }

        case .numberField:
            TextField("請輸入\(fieldTemplate.label)", value: PropertyItem.numberBinding(for: $item), formatter: NumberFormatter()).keyboardType(.numberPad)
                .font(.subheadline)
                .submitLabel(.done)
                .onSubmit {
                    hideKeyboard()
                }

        case let .multiPicker(title, fields):
            Button {
                let numberFields = fields.map { fieldTemplate.numberField(for: $0) }
                let initialValues: [String: Int] = if case let .multi(values) = item.value {
                    values
                } else {
                    [:]
                }

                pickerState = PickerState.fromFields(
                    numberFields,
                    title: title,
                    initialValues: initialValues
                ) { result in
                    item.value = .multi(result)
                }

            } label: {
                Text(fieldTemplate.displayText(item.value))
                    .foregroundColor(.blue)
            }

        case let .tagSelector(category):
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
                        if case let .tagSelector(selection) = item.value {
                            item.value = .tagSelector(TagSelection(category: selection.category, selectedTags: newTags))
                        }
                    }
                )
            )

        case let .slider(min, max, step):
            HStack {
                Slider(
                    value: Binding(
                        get: {
                            if case let .slider(val) = item.value { return val }
                            return min
                        },
                        set: { newValue in
                            item.value = .slider(newValue)
                        }
                    ),
                    in: min ... max,
                    step: step
                )
                .frame(maxWidth: 150)
                Text("\(item.value.sliderValueString)")
                    .frame(width: 40, alignment: .leading)
                if fieldTemplate.hasPhoto {
                    trailingAccessoryView()
                }
            }

        case .toggle:
            Toggle("", isOn: Binding(
                get: {
                    if case let .number(val) = item.value { return val == 1 }
                    return false
                },
                set: { newValue in
                    item.value = .number(newValue ? 1 : 0)
                }
            ))
            .labelsHidden()

        default:
            Text("⚠️ 尚未實作的 inputKind")
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
