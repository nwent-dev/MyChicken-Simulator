import SwiftUI
import SpriteKit

struct CatchTheGrainView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var menuVM: MenuViewModel
    @State private var scene = CatchTheGrainScene(size: CGSize(width: 400, height: 800))
    @StateObject private var gameVM = CatchTheGrainViewModel() // ViewModel
    
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height

    var body: some View {
        NavigationView {
            ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .onAppear {
                        scene.backgroundColor = .clear
                        scene.setViewModel(gameVM)
                    }
                    .onDisappear {
                        scene.removeAllChildren() // remove all childs
                        scene.removeAllActions() // stoping all animations
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                scene.movePlayer(to: value.location) // drag player
                            }
                    )
                
                VStack {
                    HStack {
                        VStack {
                            levelTask
                            
                            timer
                        }
                        
                        Spacer()
                        
                        HStack {
                            Button {
                                gameVM.pauseGame()
                            } label: {
                                Image("pauseBtn")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: width * 0.15)
                            }
                            
                            Button {
                                SettingsViewModel.shared.playSoundEffect(named: "tapSound")
                                dismiss()
                            } label: {
                                Image("closeBtn")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: width * 0.15)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: width*0.9)
                
                if gameVM.isGamePaused {
                    PauseView(gameVM: gameVM, dismiss: _dismiss)
                }
                
                if gameVM.isGameOver || gameVM.isGameWon {
                    GameOverView(
                        dismiss: _dismiss,
                        gameVM: gameVM,
                        menuVM: menuVM
                    )
                        .onAppear {
                            SettingsViewModel.shared.playSoundEffect(named: gameVM.isGameWon ? "winSound" :  "loseSound")
                        }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            menuVM.playGame()
        }
    }
    
    var levelTask: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("level task")
                    .foregroundStyle(.black)
                    .font(.custom("Gilroy-Regular", size: width*0.03))
                Text("\(gameVM.levelTask - gameVM.score)")
                    .foregroundStyle(.black)
                    .font(.custom("Gilroy-Heavy", size: width*0.05))
            }
            Spacer()
            
            Image("dropItem")
                .resizable()
                .scaledToFit()
                .frame(width: width*0.1)
        }
        .padding(6)
        .frame(width: width * 0.37)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.9))
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.bgView)
                .padding(.bottom, 4)
        }
    }
    
    var timer: some View {
        HStack {
            Image("clock")
                .resizable()
                .scaledToFit()
                .frame(width: width*0.06153846154)
            Text("\(gameVM.timeMinutes)")
                .font(.custom("Gilroy-Heavy", size: width*0.04))
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.9))
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.bottom, 4)
                }
            Text(":")
                .foregroundStyle(.white)
            Text("\(gameVM.timeSeconds)")
                .foregroundStyle(.black)
                .font(.custom("Gilroy-Heavy", size: width*0.04))
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.9))
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.bottom, 4)
                }
        }
        .padding(6)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.9))
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.bgView)
                .padding(.bottom, 4)
        }
        .frame(width: width * 0.37)
    }
}

#Preview {
    @StateObject var vm = MenuViewModel()
    CatchTheGrainView(menuVM: vm)
}
