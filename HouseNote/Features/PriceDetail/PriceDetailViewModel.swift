import Combine
import Foundation

final class PriceDetailViewModel: ObservableObject {
    @Published var currentListing: ListingItem?
    @Published var pastDeals: [ListingItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var expectedTotalPrice: String = ""
    @Published var expectedUnitPrice: String = ""

    private let api: PriceDetailAPIProtocol

    init(api: PriceDetailAPIProtocol = PriceDetailAPI()) {
        self.api = api
    }

    var discountPercentageString: String {
        guard let currentListing,
              let enteredPrice = Double(expectedTotalPrice),
              currentListing.totalPrice > 0 else {
            return "0"
        }
        let discount = (1 - (enteredPrice / currentListing.totalPrice)) * 100
        return String(format: "%.1f", discount)
    }

    func updateExpectedUnitPrice() {
        guard let currentListing,
              let totalPrice = Double(expectedTotalPrice) else {
            expectedUnitPrice = ""
            return
        }
        let unitPrice = totalPrice / currentListing.totalArea
        expectedUnitPrice = String(format: "%.1f", unitPrice)
    }

    func updateExpectedTotalPrice() {
        guard let currentListing,
              let unitPrice = Double(expectedUnitPrice) else {
            expectedTotalPrice = ""
            return
        }
        let totalPrice = unitPrice * currentListing.totalArea
        expectedTotalPrice = String(format: "%.1f", totalPrice)
    }

    func fetchDetail(for addressId: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await api.fetchListingDetail(addressId: addressId)
                await MainActor.run {
                    self.currentListing = response.current
                    self.pastDeals = response.history
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
