import SwiftUI

struct SliderRenderer: RowValueRenderer {
    @Binding var item: PropertyItem
    let fieldTemplate: FieldTemplate
    let isEditable: Bool

    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?

    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate, isEditable: Bool) {
        _item = item
        self.fieldTemplate = fieldTemplate
        self.isEditable = isEditable
    }

    var body: some View {
        if case let .slider(min, max, step) = fieldTemplate.inputKind {
            HStack {
                if isEditable {
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
                } else {
                    Text(item.value.sliderValueString)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                if fieldTemplate.hasPhoto {
                    trailingAccessoryView()
                        .disabled(!isEditable)
                }
            }
        } else {
            Text("⚠️ 無效的 slider 設定")
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
