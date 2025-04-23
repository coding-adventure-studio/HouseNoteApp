import SwiftUI

struct HeaderControlsView: View {
    @Binding var showStarredOnly: Bool
    let advantageCount: Int
    let disadvantageCount: Int
    let totalCount: Int

    var body: some View {
        HStack {
            Toggle("僅顯示", isOn: $showStarredOnly)
                .tint(.yellow)

            Spacer()

            ScoreView(
                advantages: advantageCount,
                disadvantages: disadvantageCount,
                total: totalCount
            )
        }
    }
}
