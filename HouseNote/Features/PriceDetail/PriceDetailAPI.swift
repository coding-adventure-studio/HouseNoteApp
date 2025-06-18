import Foundation

struct PriceDetailResponse {
    let current: ListingItem
    let history: [ListingItem]
}

protocol PriceDetailAPIProtocol {
    func fetchListingDetail(addressId: String) async throws -> PriceDetailResponse
}

final class PriceDetailAPI: PriceDetailAPIProtocol {
    func fetchListingDetail(addressId: String) async throws -> PriceDetailResponse {
        let current = ListingItem(
            addressTitle: "工學五街33號",
            address: "工學五街33號10樓之1",
            date: "113.6",
            totalPrice: 1680,
            unitPrice: 45.0,
            unitPriceWithoutParking: 45.8,
            layoutDescription: "3房/44.49坪",
            parkingPrice: 110,
            parkingArea: 9.33,
            timesSold: 0,
            totalArea: 44.49
        )

        let history = [
            ListingItem(
                addressTitle: "工學五街33號",
                address: "工學五街31號8樓之2",
                date: "112.6",
                totalPrice: 1555,
                unitPrice: 35.0,
                unitPriceWithoutParking: 40.8,
                layoutDescription: "3房/44.49坪",
                parkingPrice: 110,
                parkingArea: 9.33,
                timesSold: 2,
                totalArea: 44.49
            ),
            ListingItem(
                addressTitle: "工學五街33號",
                address: "工學五街33號2樓之3",
                date: "112.6",
                totalPrice: 1456,
                unitPrice: 34.2,
                unitPriceWithoutParking: 35.8,
                layoutDescription: "3房/42.49坪",
                parkingPrice: 100,
                parkingArea: 9.33,
                timesSold: 2,
                totalArea: 42.49
            )
        ]

        return PriceDetailResponse(current: current, history: history)
    }
}
