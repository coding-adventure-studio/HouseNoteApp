import SwiftUI

@main
struct HouseNoteApp: App {
    var body: some Scene {
        WindowGroup {
            PropertyNotesView(
                viewModel: PropertyNotesViewModel(dependency: PropertyNotesDependencyMock())
            )
        }
    }
}
