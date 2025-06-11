import SwiftUI

struct ScoreView: View {
    let advantages: Int
    let disadvantages: Int
    let total: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: 4)

            Group {
                // advantages (Green)
                Circle()
                    .trim(from: 0, to: CGFloat(advantages) / CGFloat(total))
                    .stroke(Color.green, lineWidth: 4)
                    .rotationEffect(.degrees(-90))

                // disadvantages (Red)
                Circle()
                    .trim(
                        from: CGFloat(advantages) / CGFloat(total),
                        to: CGFloat(advantages + disadvantages) / CGFloat(total)
                    )
                    .stroke(Color.red, lineWidth: 4)
                    .rotationEffect(.degrees(-90))
            }

            VStack(spacing: 0) {
                HStack(spacing: 2) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 8))
                    Text("\(advantages)")
                        .foregroundColor(.green)
                        .font(.system(size: 10))
                }

                HStack(spacing: 2) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 8))
                    Text("\(disadvantages)")
                        .foregroundColor(.red)
                        .font(.system(size: 10))
                }
            }
            .padding(2)
        }
        .frame(width: 40, height: 40)
    }
}
