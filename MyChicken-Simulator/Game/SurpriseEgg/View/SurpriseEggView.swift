import SwiftUI

struct SurpriseEggView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var menuVM: MenuViewModel
    @ObservedObject var gameVM: SurpriseEggViewModel
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    var body: some View {
        NavigationView {
            ZStack {
                Image("surpriseEggBg")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        // pause btn
                        Button {
                            gameVM.pauseGame()
                        } label: {
                            Image("pauseBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width * 0.15)
                        }
                        
                        // close btn
                        Button {
                            dismiss()
                        } label: {
                            Image("closeBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width * 0.15)
                        }
                    }
                    
                    ShadowTextView(
                        text: "CHOOSE BASKET",
                        fontName: "Gilroy-Heavy",
                        fontSize: width * 0.1,
                        textColor: Color(red: 0.722, green: 0.055, blue: 0.306),
                        outlineColor: .black,
                        outlineWidth: 1,
                        shadowColor: .black,
                        shadowOffset: CGSize(width: 1.97, height: 1.97),
                        shadowOpacity: 1
                    )
                    
                    ForEach(0..<3, content: { index in
                        Button {
                            withAnimation {
                                gameVM.spinBasket(at: index)
                            }
                        } label: {
                            Image(gameVM.activeBasketIndex == index ? "basketActive" : "basket")
                                .resizable()
                                .scaledToFit()
                        }
                    })
                    
                    Spacer()
                }
                .frame(width: width * 0.9)
                
                if gameVM.isGamePaused {
                    SurpriseEggPauseView(gameVM: gameVM, dismiss: _dismiss)
                }
                
                if gameVM.isGameWin {
                    SurpriseEggCongratulationsView(
                        dismiss: _dismiss,
                        gameVM: gameVM
                    )
                }
                
                if gameVM.isGameOver {
                    SurpriseEggGameOverView(dismiss: _dismiss, gameVM: gameVM)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            menuVM.playGame()
        }
    }
}

#Preview {
    @StateObject var menuVM: MenuViewModel = .init()
    @StateObject var gameVM: SurpriseEggViewModel = .init()
    SurpriseEggView(menuVM: menuVM, gameVM: gameVM)
}
