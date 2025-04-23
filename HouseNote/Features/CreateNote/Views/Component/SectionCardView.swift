import SwiftUI

struct SectionCardView: View {
    let section: PropertySection
    @ObservedObject var viewModel: PropertyNotesViewModel
    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                isExpanded.toggle()
            } label: {
                HStack {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    Text(section.type.title)
                        .font(.headline)
                    Text("（\(section.completedCount)/\(section.totalCount)）")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded {
                ForEach(section.items) { item in
                    PropertyItemRowView(
                        item: item,
                        toggleStar: { viewModel.toggleStar(for: item.id) },
                        toggleStatus: { viewModel.toggleStatus(for: item.id) },
                        updateValue: { value in
                            viewModel.updateValue(for: item.id, value: value)
                        }
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
    let item: PropertyItem
    let toggleStar: () -> Void
    let toggleStatus: () -> Void
    let updateValue: (ItemValue) -> Void

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
                .frame(width: 20, height: 20)
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
        switch item.value {
        case let .text(value):
            TextField("請輸入", text: Binding(
                get: { value },
                set: { updateValue(.text($0)) }
            ))

        case let .number(value):
            TextField("", value: Binding(
                get: { value },
                set: { updateValue(.number($0)) }
            ), formatter: NumberFormatter())

        case let .floor(current, total):
            Button {
                pickerState = PickerState.floor(current: current, total: total) {
                    updateValue(.floor(current: $0.current, total: $0.total))
                }
            } label: {
                HStack {
                    Text("\(current)/\(total) 樓")
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 4)
            }

        case let .layout(rooms, living, bathrooms, balconies):
            Button {
                let info = LayoutResult(rooms: rooms, living: living, bathrooms: bathrooms, balconies: balconies)
                pickerState = PickerState.layout(info: info) {
                    updateValue(.layout(
                        rooms: $0.rooms,
                        livingRooms: $0.living,
                        bathrooms: $0.bathrooms,
                        balconies: $0.balconies
                    ))
                }
            } label: {
                Text("\(rooms)房 \(living)廳 \(bathrooms)衛 \(balconies)陽台")
                    .foregroundColor(.blue)
            }
        }
    }
}

// MARK: - PickerState Factory Extension

struct LayoutResult {
    let rooms: Int
    let living: Int
    let bathrooms: Int
    let balconies: Int
}

extension PickerState {
    struct FloorResult {
        let current: Int
        let total: Int
    }

    static func floor(current: Int, total: Int, onDone: @escaping (FloorResult) -> Void) -> PickerState {
        let initial: [ItemFieldType: Int] = [
            .floorCurrent: current,
            .floorTotal: total
        ]
        return PickerState(
            title: "樓層資訊",
            fields: ItemFieldType.floorFields.map(\.numberField),
            initialValues: Dictionary(uniqueKeysWithValues: initial.map { ($0.key.numberField, $0.value) }),
            onConfirm: { result in
                let current = result.first(where: { $0.key.label == ItemFieldType.floorCurrent.rawValue })?.value ?? 1
                let total = result.first(where: { $0.key.label == ItemFieldType.floorTotal.rawValue })?.value ?? 1
                onDone(FloorResult(current: current, total: total))
            }
        )
    }

    static func layout(info: LayoutResult, onDone: @escaping (LayoutResult) -> Void) -> PickerState {
        let initial: [ItemFieldType: Int] = [
            .layoutRooms: info.rooms,
            .layoutLivingRooms: info.living,
            .layoutBathrooms: info.bathrooms,
            .layoutBalconies: info.balconies
        ]

        return PickerState(
            title: "選擇格局",
            fields: ItemFieldType.layoutFields.map(\.numberField),
            initialValues: Dictionary(uniqueKeysWithValues: initial.map { ($0.key.numberField, $0.value) }),
            onConfirm: { result in
                func getValue(for fieldType: ItemFieldType) -> Int {
                    result.first(where: { $0.key.label == fieldType.rawValue })?.value ?? 0
                }
                let layoutResult = LayoutResult(
                    rooms: getValue(for: .layoutRooms),
                    living: getValue(for: .layoutLivingRooms),
                    bathrooms: getValue(for: .layoutBathrooms),
                    balconies: getValue(for: .layoutBalconies)
                )
                onDone(layoutResult)
            }
        )
    }
}
