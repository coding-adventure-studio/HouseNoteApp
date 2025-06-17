import SwiftUI

struct TextFieldRenderer: RowValueRenderer {
    @Binding var item: PropertyItem
    let fieldTemplate: FieldTemplate

    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?

    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate) {
        _item = item
        self.fieldTemplate = fieldTemplate
    }

    var body: some View {
        HStack(spacing: 8) {
            if case let .text(value) = item.value {
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
            } else {
                Text("⚠️ 預期是 text，但實際是 \(item.value)")
            }
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
                        Label("選擇其他照片", systemImage: "photo.on.rectangle")
                    }

                    Button(role: .destructive, action: {
                        selectedImage = nil
                    }) {
                        Label("刪除", systemImage: "trash")
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
