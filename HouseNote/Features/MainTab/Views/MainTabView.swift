import SwiftUI

struct MainTabView: View {
    @StateObject private var notesViewModel = NotesViewModel()
    @State private var selectedTab = 0
    private let dependency = EditNoteDependencyMock()

    var body: some View {
        TabView(selection: $selectedTab) {
            PropertyListView(viewModel: notesViewModel)
                .tabItem {
                    Label("筆記列表", systemImage: "list.bullet")
                }
                .tag(0)

            EditNoteView(
                mode: .create,
                onSaveSuccess: { property in
                    notesViewModel.addNote(title: property.name, content: "\(property.id)", sections: property.sections)
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
