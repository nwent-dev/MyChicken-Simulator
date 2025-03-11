import Foundation

struct Product: Identifiable, Hashable, Codable {
    var id = UUID()
    var image: String
    var price: Int
    var isBuyed: Bool
    var productType: ProductType
}
