import SwiftUI

struct ScoreView: View {
    let advantages: Int
    let disadvantages: Int
    let total: Int

    var body: some View {
        ZStack {
            // 背景圓環
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: 4)

            Group {
                // 優點圓環（綠色）
                Circle()
                    .trim(from: 0, to: CGFloat(advantages) / CGFloat(total))
                    .stroke(Color.green, lineWidth: 4)
                    .rotationEffect(.degrees(-90))

                // 缺點圓環（紅色）
                Circle()
                    .trim(
                        from: CGFloat(advantages) / CGFloat(total),
                        to: CGFloat(advantages + disadvantages) / CGFloat(total)
                    )
                    .stroke(Color.red, lineWidth: 4)
                    .rotationEffect(.degrees(-90))
            }

            // 中心數字顯示 - 移除背景，改用更精確的布局
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
            // 移除了 .background(Color.white)
            .padding(2)
        }
        .frame(width: 40, height: 40)
    }
}
