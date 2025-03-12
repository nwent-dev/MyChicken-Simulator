import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var rotationAngle: Double = 0
    @State private var loadingProgress: Int = 0
    
    var body: some View {
        if isActive {
            HomeView()
        } else {
            ZStack {
                Image("bg1")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                    
                    ProgressCircleView(rotationAngle: $rotationAngle)
                        .frame(
                            width: UIScreen.main.bounds.width * 0.2,
                            height: UIScreen.main.bounds.width * 0.2
                        )
                        .padding(.top, UIScreen.main.bounds.height * 0.1)
                    
                    Text("\(loadingProgress)%")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.05)
                }
                .onAppear {
                    startLoadingAnimation()
                }
            }
        }
    }
    
    private func startLoadingAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if loadingProgress < 100 {
                loadingProgress += 5
                withAnimation(.linear(duration: 0.1)) {
                    rotationAngle += 30
                }
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

struct ProgressCircleView: View {
    @Binding var rotationAngle: Double
    
    var body: some View {
        Circle()
            .trim(from: 0.2, to: 1.0)
            .stroke(Color.black, lineWidth: 8)
            .rotationEffect(.degrees(rotationAngle))
            .animation(.linear(duration: 0.1), value: rotationAngle)
    }
}

struct MainView: View {
    var body: some View {
        Text("Главный экран")
            .font(.largeTitle)
    }
}

#Preview {
    SplashScreenView()
}
