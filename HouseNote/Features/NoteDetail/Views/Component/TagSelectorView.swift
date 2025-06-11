import SwiftUI

struct TagSelectorView: View {
    let options: [String]
    @Binding var selectedTags: Set<String>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    TagChipView(
                        label: option,
                        isSelected: selectedTags.contains(option),
                        onTap: {
                            if selectedTags.contains(option) {
                                selectedTags.remove(option)
                            } else {
                                selectedTags.insert(option)
                            }
                        }
                    )
                }
            }
        }
    }
}

struct TagChipView: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Text(label)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .blue : .primary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
            )
            .onTapGesture(perform: onTap)
    }
}
