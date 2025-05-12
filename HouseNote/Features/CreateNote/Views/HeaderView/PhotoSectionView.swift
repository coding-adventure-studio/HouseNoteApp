import SwiftUI

struct PhotoSectionView: View {
    let onAddPhoto: () -> Void

    var body: some View {
        VStack {
            Button(action: onAddPhoto) {
                VStack(spacing: 12) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)

                    Text("新增相片")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 0)
    }
}
