import SwiftUI

struct MainTabView: View {
    @StateObject private var notesViewModel = NotesViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            PropertyListView(viewModel: notesViewModel)
                .tabItem {
                    Label("筆記列表", systemImage: "list.bullet")
                }
                .tag(0)

            EditNoteView(
                viewModel: EditNoteViewModel(dependency: EditNoteDependencyMock()),
                onSaveSuccess: { property in
                    notesViewModel.addNote(title: property.name, content: "\(property.id)")
                    selectedTab = 0
                }
            )
            .tabItem {
                Label("新增筆記", systemImage: "plus.circle")
            }
            .tag(1)
        }
    }
}

#Preview {
    MainTabView()
}
