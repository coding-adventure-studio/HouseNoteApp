import SwiftUI

struct SectionCardView: View {
    @Binding var section: PropertySection
    @ObservedObject var viewModel: PropertyNotesViewModel
    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                isExpanded.toggle()
            } label: {
                HStack {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    Text(section.type.displayName)
                        .font(.headline)
                    Text("（\(section.completedCount)/\(section.totalCount)）")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded {
                ForEach(Array(zip(section.items.indices, $section.items)), id: \.0) { _, itemBinding in
                    let itemId = itemBinding.wrappedValue.id
                    let itemType = itemBinding.wrappedValue.type

                    PropertyItemRowView(
                        item: itemBinding,
                        toggleStar: { viewModel.toggleStar(for: itemId) },
                        toggleStatus: { viewModel.toggleStatus(for: itemId) },
                        fieldTemplate: fieldTemplate(for: itemType)
                    )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct PropertyItemRowView: View {
    @Binding var item: PropertyItem
    let toggleStar: () -> Void
    let toggleStatus: () -> Void
    let fieldTemplate: FieldTemplate

    @State private var pickerState: PickerState?

    var body: some View {
        HStack {
            Button(action: toggleStar) {
                Image(systemName: item.isStarred ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            
            itemValueEditor

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
                TextField("請輸入\(fieldTemplate.label)", text: Binding(
                    get: { value },
                    set: { item.value = .text($0) }
                ))
                .font(.subheadline)
            } else {
                Text("⚠️ 預期是 text，但實際是 \(item.value)")
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

        default:
            Text("⚠️ 尚未實作的 inputKind")
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
