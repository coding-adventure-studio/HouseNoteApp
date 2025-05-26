import SwiftUI

struct PropertyListView: View {
    @ObservedObject var viewModel: NotesViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.notes) { note in
                VStack(alignment: .leading) {
                    Text(note.title)
                        .font(.headline)
                    Text(note.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(note.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("我的筆記")
        }
    }
}

#Preview {
    PropertyListView(viewModel: NotesViewModel())
}
