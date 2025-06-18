import SwiftUI

struct PriceDetailCardView: View {
    let listing: ListingItem
    let isCurrentListing: Bool
    @ObservedObject var viewModel: PriceDetailViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(listing.address)
                    .font(.headline)
                Spacer()
                Text("歷史成交\(listing.timesSold)次")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .background(Color.yellow.opacity(0.4))
                    .cornerRadius(4)
            }
            .padding()
            .background(Color.yellow)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(listing.date)
                        .font(.subheadline)
                    Text("\(Int(listing.totalPrice))萬")
                        .font(.title2)
                        .foregroundColor(.red)
                    Text(listing.layoutDescription)
                        .font(.footnote)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(listing.unitPrice))萬/坪")
                        .font(.title2)
                        .foregroundColor(.red)
                    Text("含車位計算")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)

            HStack {
                Text("單價扣除車位: \(Int(listing.unitPriceWithoutParking))萬/坪")
                Spacer()
                Text("車位: \(Int(listing.parkingPrice))萬 / \(listing.parkingArea)坪")
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding([.horizontal, .bottom])

            if isCurrentListing {
                PriceEstimatorView(listing: listing, viewModel: viewModel)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}
