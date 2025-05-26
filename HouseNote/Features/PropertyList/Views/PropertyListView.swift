import SwiftUI

struct PropertyListView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("筆記列表")
            }
            .navigationTitle("我的筆記")
        }
    }
}

#Preview {
    PropertyListView()
}
