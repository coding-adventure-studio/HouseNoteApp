import SwiftUI

enum MainTab: Hashable {
    case list
    case create
}

struct MainTabView: View {
    @StateObject private var notesViewModel = NotesViewModel()
    @State private var selectedTab: MainTab = .list
    @State private var showCreateSheet = false
    private let dependency = NoteDetailDependencyMock()

    var body: some View {
        TabView(selection: $selectedTab) {
            PropertyListView(viewModel: notesViewModel)
                .tabItem {
                    Label("筆記列表", systemImage: "list.bullet")
                }
                .tag(MainTab.list)

            Color.clear
                .tabItem {
                    Label("新增筆記", systemImage: "plus.circle")
                }
                .tag(MainTab.create)
        }
        .onChange(of: selectedTab) { tab in
            if tab == .create {
                showCreateSheet = true
                selectedTab = .list
            }
        }
        .sheet(isPresented: $showCreateSheet) {
            NoteDetailView(
                viewModel: NoteDetailViewModel(mode: .create, dependency: dependency),
                onSaveSuccess: { property in
                    notesViewModel.addNote(title: property.name, sections: property.sections)
                    showCreateSheet = false
                }
            )
        }
    }
}

#Preview {
    MainTabView()
}
