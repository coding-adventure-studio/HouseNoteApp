import SwiftUI

// MARK: - Custom Navigation Buttons

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .foregroundColor(.primary)
        }
    }
}
