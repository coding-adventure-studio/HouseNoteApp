import SwiftUI

struct LockButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "lock")
                .foregroundColor(.primary)
        }
    }
}
