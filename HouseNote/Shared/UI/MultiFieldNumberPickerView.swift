import SwiftUI

struct MultiFieldNumberPickerView: View {
    let fields: [NumberField]
    let title: String
    let onConfirm: ([NumberField: Int]) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selected: [NumberField: Int]

    init(
        fields: [NumberField],
        initialValues: [NumberField: Int],
        title: String,
        onConfirm: @escaping ([NumberField: Int]) -> Void
    ) {
        self.fields = fields
        self.title = title
        self.onConfirm = onConfirm
        _selected = State(initialValue: initialValues)
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Button("取消") { dismiss() }
                Spacer()
                Text(title).bold()
                Spacer()
                Button("確定") {
                    onConfirm(selected)
                    dismiss()
                }
                .foregroundColor(.orange)
            }
            .padding()

            // Pickers
            HStack(spacing: 12) {
                ForEach(fields, id: \.self) { field in
                    VStack {
                        Text(field.label)
                            .font(.caption)
                            .foregroundColor(.gray)

                        Picker("", selection: Binding(
                            get: { selected[field, default: field.range.lowerBound] },
                            set: { selected[field] = $0 }
                        )) {
                            ForEach(field.range, id: \.self) { val in
                                Text("\(val)\(field.suffix)").tag(val)
                            }
                        }
                        .frame(width: 70, height: 120)
                        .clipped()
                        .pickerStyle(.wheel)
                    }
                }
            }

            Spacer()
        }
        .presentationDetents([.fraction(0.4)])
    }
}
