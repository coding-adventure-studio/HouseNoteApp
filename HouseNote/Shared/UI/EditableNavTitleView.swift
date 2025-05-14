import SwiftUI

struct EditableNavTitleView: View {
    @Binding var title: String
    @Binding var isEditing: Bool

    var body: some View {
        Group {
            if isEditing {
                TextField("建案名稱", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 200)
                    .onSubmit {
                        isEditing = false
                        hideKeyboard()
                    }
            } else {
                Text(title)
                    .onTapGesture { isEditing = true }
            }
        }
    }
}
