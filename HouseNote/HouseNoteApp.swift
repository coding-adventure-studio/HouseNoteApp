import SwiftUI

@main
struct HouseNoteApp: App {
    var body: some Scene {
        WindowGroup {
            PropertyNotesView(viewModel: PropertyNotesViewModel(property: mockProperty))
        }
    }
}
