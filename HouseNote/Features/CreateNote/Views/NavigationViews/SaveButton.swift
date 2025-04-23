import SwiftUI

struct SaveButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "checkmark")
                .foregroundColor(.primary)
        }
    }
}
