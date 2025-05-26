import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PropertyListView()
                .tabItem {
                    Label("筆記列表", systemImage: "list.bullet")
                }

            PropertyNotesView(
                viewModel: PropertyNotesViewModel(dependency: PropertyNotesDependencyMock())
            )
            .tabItem {
                Label("新增筆記", systemImage: "plus.circle")
            }
        }
    }
}

#Preview {
    MainTabView()
}
