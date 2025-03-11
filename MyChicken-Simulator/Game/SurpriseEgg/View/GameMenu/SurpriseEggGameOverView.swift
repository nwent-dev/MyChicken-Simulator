import SwiftUI

struct SurpriseEggGameOverView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var gameVM: SurpriseEggViewModel
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            
            VStack {
                VStack {
                    ShadowTextView(
                        text: "GAME OVER",
                        fontName: "Gilroy-Heavy",
                        fontSize: width * 0.12,
                        textColor: Color(red: 0.722, green: 0.055, blue: 0.306),
                        outlineColor: .black,
                        outlineWidth: 1,
                        shadowColor: .black,
                        shadowOffset: CGSize(width: 1.97, height: 1.97),
                        shadowOpacity: 1
                    )
                    
                    Text("YOU HAVE EARNED")
                        .font(.custom("Gilroy-Regular", size: width*0.05))
                    
                    HStack {
                        Text("0")
                            .foregroundStyle(.black)
                            .font(.custom("Gilroy-Heavy", size: width*0.1))
                        
                        Image("egg")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width*0.1)
                    }
                    .padding()
                    .padding(.horizontal)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.7))
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .padding(.bottom, 4)
                    }
                    
                    HStack {
                        Button {
                            gameVM.resumeGame()
                        } label: {
                            Image("restartBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width*0.25)
                        }
                        Button {
                            dismiss()
                        } label: {
                            Image("quitBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width*0.25)
                        }
                    }
                }
                .padding()
                .padding(.vertical)
                .frame(width: width*0.9)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.opacity(0.7))
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.bgView)
                        .padding(.bottom, 4)
                }
            }
        }
    }
}

#Preview {
    @StateObject var gameVM = SurpriseEggViewModel()
    SurpriseEggGameOverView(gameVM: gameVM)
}
