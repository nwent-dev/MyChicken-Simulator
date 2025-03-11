import Foundation

class ShopViewModel: ObservableObject {
    @Published var selectedProductsType: ProductType = .cloth
    @Published var selectedCloth: Product?
    @Published var chickenWithCloth: String = "chicken"
    @Published var clotheProducts: [Product] = [
        Product(image: "glasses", price: 30, isBuyed: false, productType: .cloth),
        Product(image: "hat", price: 60, isBuyed: false, productType: .cloth),
        Product(image: "pinkBaterfly", price: 25, isBuyed: false, productType: .cloth),
        Product(image: "blueBaterfly", price: 20, isBuyed: false, productType: .cloth),
    ]
    @Published var locationProducts: [Product] = [
        Product(image: "loc1", price: 50, isBuyed: false, productType: .location),
        Product(image: "loc2", price: 55, isBuyed: false, productType: .location),
        Product(image: "loc3", price: 40, isBuyed: false, productType: .location),
        Product(image: "loc4", price: 63, isBuyed: false, productType: .location),
        Product(image: "loc5", price: 63, isBuyed: false, productType: .location),
        Product(image: "loc6", price: 63, isBuyed: false, productType: .location),
        Product(image: "loc7", price: 63, isBuyed: false, productType: .location),
    ]
    
    private let clotheProductsKey = "clotheProducts"
    private let locationProductsKey = "locationProducts"
    private let selectedClothKey = "selectedCloth"
    private let chickenWithClothKey = "chickenWithCloth"

    init() {
        loadData()
    }
    
    func buyProduct(at index: Int) {
        if MoneyManager.shared.money >= clotheProducts[index].price {
            MoneyManager.shared.money -= clotheProducts[index].price
            clotheProducts[index].isBuyed = true
            saveData()
            SettingsViewModel.shared.playSoundEffect(named: "purchaseSound")
        }
    }
    
    /// choose choth for chicken
    func selectCloth(at index: Int) {
        selectedCloth = clotheProducts[index]
        switch selectedCloth?.image ?? "" {
            case "glasses":
                chickenWithCloth = "chickenInGlasses"
            case "hat":
                chickenWithCloth = "chickenInHat"
            case "pinkBaterfly":
                chickenWithCloth = "chickenInPinkButterfly"
            case "blueBaterfly":
                chickenWithCloth = "chickenInBlueButterfly"
            default:
                break
        }
        saveData()
    }
    
    /// save data in `UserDefaults`
    private func saveData() {
        let encoder = JSONEncoder()
        
        if let encodedClotheProducts = try? encoder.encode(clotheProducts) {
            UserDefaults.standard.set(encodedClotheProducts, forKey: clotheProductsKey)
        }
        
        if let encodedLocationProducts = try? encoder.encode(locationProducts) {
            UserDefaults.standard.set(encodedLocationProducts, forKey: locationProductsKey)
        }
        
        if let selectedCloth = selectedCloth {
            if let encodedSelectedCloth = try? encoder.encode(selectedCloth) {
                UserDefaults.standard.set(encodedSelectedCloth, forKey: selectedClothKey)
            }
        }
        
        UserDefaults.standard.set(chickenWithCloth, forKey: chickenWithClothKey)
    }
    
    /// Load data at `UserDefaults`
    private func loadData() {
        let decoder = JSONDecoder()
        
        if let savedClotheProducts = UserDefaults.standard.data(forKey: clotheProductsKey),
           let decodedClotheProducts = try? decoder.decode([Product].self, from: savedClotheProducts) {
            clotheProducts = decodedClotheProducts
        }
        
        if let savedLocationProducts = UserDefaults.standard.data(forKey: locationProductsKey),
           let decodedLocationProducts = try? decoder.decode([Product].self, from: savedLocationProducts) {
            locationProducts = decodedLocationProducts
        }
        
        if let savedSelectedCloth = UserDefaults.standard.data(forKey: selectedClothKey),
           let decodedSelectedCloth = try? decoder.decode(Product.self, from: savedSelectedCloth) {
            selectedCloth = decodedSelectedCloth
        }
        
        if let savedChickenWithCloth = UserDefaults.standard.string(forKey: chickenWithClothKey) {
            chickenWithCloth = savedChickenWithCloth
        }
    }
}
