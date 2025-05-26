import SwiftUI

struct MainTabView: View {
    @StateObject private var notesViewModel = NotesViewModel()
    var body: some View {
        TabView {
            PropertyListView(viewModel: notesViewModel)
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
