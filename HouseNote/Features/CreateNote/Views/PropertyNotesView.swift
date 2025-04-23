import SwiftUI

#Preview {
    PropertyNotesView(viewModel: PropertyNotesViewModel(property: mockProperty))
}

struct PropertyNotesView: View {
    @StateObject var viewModel: PropertyNotesViewModel
    @State private var editingTitle = false

    var body: some View {
        NavigationView {
            PropertyNotesContentView(viewModel: viewModel, editingTitle: $editingTitle)
                .navigationBarItems(
                    leading: BackButton(action: viewModel.dismissView),
                    trailing: HStack {
                        LockButton(action: viewModel.lockProperty)
                        SaveButton(action: viewModel.saveProperty)
                    }
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        EditableNavTitleView(
                            title: $viewModel.property.name,
                            isEditing: $editingTitle
                        )
                    }
                }
        }
    }
}
