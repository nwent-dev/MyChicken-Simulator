import SwiftUI

struct SurpriseEggPauseView: View {
    @ObservedObject var gameVM: SurpriseEggViewModel
    @Environment(\.dismiss) var dismiss
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                ShadowTextView(
                    text: "PAUSE",
                    fontName: "Gilroy-Heavy",
                    fontSize: width * 0.12,
                    textColor: Color(red: 0.722, green: 0.055, blue: 0.306),
                    outlineColor: .black,
                    outlineWidth: 1,
                    shadowColor: .black,
                    shadowOffset: CGSize(width: 1.97, height: 1.97),
                    shadowOpacity: 1
                )
                
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
                        SettingsViewModel.shared.playSoundEffect(named: "tapSound")
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

#Preview {
    @StateObject var vm = CatchTheGrainViewModel()
    PauseView(gameVM: vm)
}
