import SwiftUI

struct MenuView: View {
    @StateObject var menuVM = MenuViewModel()
    
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
                            outlineColor: .black, // Цвет обводки
                            outlineWidth: 1, // Толщина обводки
                            shadowColor: .black, // Цвет тени
                            shadowOffset: CGSize(width: 1.97, height: 1.97), // Смещение тени
                            shadowOpacity: 1 // Прозрачность тени
                        )
                        Spacer()
                        ZStack {
                            Image("eggsBg")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.2717948718)
                            
                            HStack {
                                Text("\(MoneyManager.shared.money)")
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
                    
                    Image("chicken")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.4512820513)
                        .padding(.top)
                    
                    HStack {
                        Button {
                            self.menuVM.isFeedMenuOpen = true
                        } label: {
                            Image("feedBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.2632564103)
                        }
                        
                        Button {
                            self.menuVM.isDreamMenuOpen = true
                        } label: {
                            Image("dreamBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.2632564103)
                        }
                        
                        Button {
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
    MenuView()
}
