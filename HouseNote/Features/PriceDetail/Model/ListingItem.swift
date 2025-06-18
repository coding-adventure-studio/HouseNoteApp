import SwiftUI

struct ListingItem: Identifiable {
    let id = UUID()
    let addressTitle: String
    let address: String
    let date: String
    let totalPrice: Double
    let unitPrice: Double
    let unitPriceWithoutParking: Double
    let layoutDescription: String
    let parkingPrice: Double
    let parkingArea: Double
    let timesSold: Int
    let totalArea: Double
}
