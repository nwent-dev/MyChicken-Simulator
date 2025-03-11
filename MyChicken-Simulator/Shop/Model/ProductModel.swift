struct Product: Hashable, Encodable, Decodable {
    var image: String
    var price: Int
    var isBuyed: Bool
    var productType: ProductType
}
