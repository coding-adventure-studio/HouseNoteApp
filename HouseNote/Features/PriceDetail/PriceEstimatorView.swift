import SwiftUI

struct PriceEstimatorView: View {
    let listing: ListingItem
    @ObservedObject var viewModel: PriceDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("議價折扣")
                .font(.caption)
                .foregroundColor(.gray)

            Text("\(viewModel.discountPercentageString)％")
                .font(.title3)
                .foregroundColor(.red)
                .bold()

            HStack {
                VStack(alignment: .leading) {
                    Text("期望總價")
                        .font(.caption)
                    TextField("", text: $viewModel.expectedTotalPrice)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: viewModel.expectedTotalPrice) { _ in
                            viewModel.updateExpectedUnitPrice()
                        }
                }

                VStack(alignment: .leading) {
                    Text("期望單價")
                        .font(.caption)
                    TextField("", text: $viewModel.expectedUnitPrice)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: viewModel.expectedUnitPrice) { _ in
                            viewModel.updateExpectedTotalPrice()
                        }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding([.horizontal, .bottom])
    }
}
