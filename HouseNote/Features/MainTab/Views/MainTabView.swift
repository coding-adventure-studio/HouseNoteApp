import SwiftUI

enum MainTab: Hashable {
    case list
    case create
}

struct MainTabView: View {
    @StateObject private var notesViewModel = NotesViewModel()
    @State private var selectedTab: MainTab = .list
    @StateObject private var newNoteViewModel = NoteDetailViewModel(mode: .create, dependency: NoteDetailDependencyMock())
    private let dependency = NoteDetailDependencyMock()

    var body: some View {
        TabView(selection: $selectedTab) {
            PropertyListView(viewModel: notesViewModel)
                .tabItem {
                    Label("筆記列表", systemImage: "list.bullet")
                }
                .tag(MainTab.list)

            NoteDetailView(
                viewModel: newNoteViewModel,
                onSaveSuccess: { property in
                    notesViewModel.addNote(title: property.name, sections: property.sections)
                    selectedTab = .list
                    newNoteViewModel.reset()
                }
            )
            .tabItem {
                Label("新增筆記", systemImage: "plus.circle")
            }
            .tag(MainTab.create)
        }
        .onChange(of: selectedTab) { tab in
            if tab == .create {
                newNoteViewModel.reset()
            }
        }
    }
}

#Preview {
    MainTabView()
}
