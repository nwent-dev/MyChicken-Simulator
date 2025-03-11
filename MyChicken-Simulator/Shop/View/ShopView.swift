import SwiftUI

struct ShopView: View {
    @ObservedObject var moneyManager = MoneyManager.shared
    @ObservedObject var shopVM: ShopViewModel
    
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Image("bg1")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    ShadowTextView(
                        text: "SHOP",
                        fontName: "Gilroy-Heavy",
                        fontSize: width * 0.12,
                        textColor: Color(red: 0.722, green: 0.055, blue: 0.306),
                        outlineColor: .black,
                        outlineWidth: 1,
                        shadowColor: .black,
                        shadowOffset: CGSize(width: 1.97, height: 1.97),
                        shadowOpacity: 1
                    )
                    
                    Spacer()
                    
                    HStack {
                        Text("\(moneyManager.money)")
                            .font(.custom("Gilroy-Heavy", size: width*0.1))
                            .foregroundStyle(.black)
                        
                        Image("egg")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.1)
                    }
                    .padding(.horizontal)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .padding(.bottom, 4)
                    }
                }
                
                HStack {
                    Button {
                        SettingsViewModel.shared.playSoundEffect(named: "tapSound")
                        shopVM.selectedProductsType = .cloth
                    } label: {
                        Image(
                            shopVM.selectedProductsType == .cloth ? "clothesBtnActive" : "clothesBtn"
                        )
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.35)
                    }
                    
                    Button {
                        SettingsViewModel.shared.playSoundEffect(named: "tapSound")
                        shopVM.selectedProductsType = .location
                    } label: {
                        Image(
                            shopVM.selectedProductsType == .location ? "locationBtnActive" : "locationBtn"
                        )
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.35)
                    }
                }
                
                if shopVM.selectedProductsType == .cloth {
                    clothes
                        .padding(.bottom, height * 0.1)
                } else {
                    locations
                        .padding(.bottom, height * 0.1)
                }
            }
            .frame(width: width * 0.9)
        }
    }
    
    var clothes: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(shopVM.clotheProducts.indices, id: \.self) { index in
                    ProductItemView(
                        image: shopVM.clotheProducts[index].image,
                        price: shopVM.clotheProducts[index].price,
                        isBuyed: shopVM.clotheProducts[index].isBuyed
                    ) {
                        if shopVM.clotheProducts[index].isBuyed {
                            shopVM.selectCloth(at: index)
                        } else {
                            shopVM.buyProduct(at: index)
                        }
                    }
                }
            }
        }
    }

    var locations: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(shopVM.locationProducts.indices, id: \.self) { index in
                    ProductItemView(
                        image: shopVM.locationProducts[index].image,
                        price: shopVM.locationProducts[index].price,
                        isBuyed: shopVM.locationProducts[index].isBuyed
                    ) {
                        shopVM.buyProduct(at: index)
                    }
                }
            }
        }
    }
}

#Preview {
    ShopView(shopVM: ShopViewModel())
}
