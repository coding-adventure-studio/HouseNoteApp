import SwiftUI

struct PriceDetailView: View {
    @StateObject private var viewModel = PriceDetailViewModel()
    let addressId: String

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("載入中...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text("⚠️ 錯誤：\(error)")
                        .foregroundColor(.red)
                    Button("重試") {
                        viewModel.fetchDetail(for: addressId)
                    }
                }
            } else if let current = viewModel.currentListing {
                ScrollView {
                    VStack(spacing: 16) {
                        PriceDetailCardView(
                            listing: current,
                            isCurrentListing: true,
                            viewModel: viewModel
                        )
                        ForEach(viewModel.pastDeals) { deal in
                            PriceDetailCardView(
                                listing: deal,
                                isCurrentListing: false,
                                viewModel: viewModel
                            )
                        }
                    }
                    .padding(.top)
                }
                .navigationTitle(current.addressTitle)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            viewModel.fetchDetail(for: addressId)
        }
    }
}

struct PriceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PriceDetailView(addressId: "mock-id")
        }
    }
}
