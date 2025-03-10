import SwiftUI

struct GameView: View {
    @StateObject var gameVM = GameViewModel()
    
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Image("bg1")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        
                    } label: {
                        Image("backBtn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.1538461538)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("\(MoneyManager.shared.money)")
                            .font(.custom("Gilroy-Heavy", size: width * 0.09))
                        Image("egg")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.08717948718)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.7))
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .padding(.bottom, 4)
                    }
                }
                
                Spacer()
                
                NavigationLink {
                    
                } label: {
                    Image("catchTheGrainBtn")
                        .resizable()
                        .scaledToFit()
                }
                
                NavigationLink {
                    
                } label: {
                    Image("supriseEggBtn")
                        .resizable()
                        .scaledToFit()
                }
                
//                Button {
//                    
//                } label: {
//                    
//                }
//                Button {
//                    
//                } label: {
//                    
//                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    GameView()
}
