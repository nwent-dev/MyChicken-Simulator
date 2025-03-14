import SwiftUI

struct MenuView: View {
    @ObservedObject var menuVM: MenuViewModel
    @ObservedObject var shopVM: ShopViewModel
    @ObservedObject var moneyManager = MoneyManager.shared
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("bg2")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        ShadowTextView(
                            text: "Home",
                            fontName: "Gilroy-Heavy",
                            fontSize: geometry.size.width * 0.13,
                            textColor: Color(red: 0.722, green: 0.055, blue: 0.306),
                            outlineColor: .black,
                            outlineWidth: 1,
                            shadowColor: .black,
                            shadowOffset: CGSize(width: 1.97, height: 1.97),
                            shadowOpacity: 1
                        )
                        Spacer()
                        ZStack {
                            Image("eggsBg")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.2717948718)
                            
                            HStack {
                                Text("\(moneyManager.money)")
                                    .foregroundStyle(.black)
                                    .font(.custom("Gilroy-Heavy", size: 35))
                                
                                Image("egg")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.08717948718)
                            }
                        }
                    }
                    HStack {
                        VStack {
                            ProgressOverlayView(
                                image: "foodStatus",
                                fillColor: Color.blue,
                                progress: $menuVM.foodProgress
                            )
                            ProgressOverlayView(
                                image: "moodStatus",
                                fillColor: Color.orange,
                                progress: $menuVM.moodProgress
                            )
                            ProgressOverlayView(
                                image: "tirednessStatus",
                                fillColor: Color.red,
                                progress: $menuVM.tirednessProgress
                            )
                        }
                        .frame(width: geometry.size.width * 0.4)
                        
                        Spacer()
                    }
                    
                    Image(shopVM.chickenWithCloth)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.4512820513)
                        .padding(.top)
                    
                    HStack {
                        Button {
                            SettingsViewModel.shared.playSoundEffect(named: "tapSound")
                            self.menuVM.isFeedMenuOpen = true
                        } label: {
                            Image("feedBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.2632564103)
                        }
                        
                        Button {
                            SettingsViewModel.shared.playSoundEffect(named: "tapSound")
                            self.menuVM.isDreamMenuOpen = true
                        } label: {
                            Image("dreamBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.2632564103)
                        }
                        
                        Button {
                            SettingsViewModel.shared.playSoundEffect(named: "tapSound")
                            menuVM.isCareMenuOpened = true
                        } label: {
                            Image("careBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.2632564103)
                        }
                    }
                    .padding()
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.7))
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.bgView)
                            .padding(.bottom, 4)
                    }

                    
                    Spacer()
                }
                .padding(.horizontal)
                
                if menuVM.isFeedMenuOpen {
                    FeedView(menuVM: menuVM)
                }
                
                if menuVM.isDreamMenuOpen {
                    DreamView(menuVM: menuVM)
                }
                
                if menuVM.isCareMenuOpened {
                    CareView(menuVM: menuVM)
                }
            }
        }
    }
}



#Preview {
    @StateObject var vm = MenuViewModel()
    MenuView(menuVM: vm, shopVM: ShopViewModel())
}
