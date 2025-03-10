import SwiftUI

struct OnboardingView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("bg1")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        // Skip button
                        Button {
                            // skip action
                        } label: {
                            Image("skipBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.2435897436)
                        }
                        .opacity(onboardingVM.currentTextIndex == 3 ? 0 : 1)
                    }
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width*0.5918717949)
                    
                    // Text
                    VStack {
                        ShadowTextView(
                            text: onboardingVM
                                .titles[onboardingVM.currentTextIndex],
                            fontName: "Gilroy-Heavy",
                            fontSize: geometry.size.width * 0.1,
                            textColor: Color(red: 0.722, green: 0.055, blue: 0.306),
                            outlineColor: .black, // Цвет обводки
                            outlineWidth: 1, // Толщина обводки
                            shadowColor: .black, // Цвет тени
                            shadowOffset: CGSize(width: 1.97, height: 1.97), // Смещение тени
                            shadowOpacity: 1 // Прозрачность тени
                        )
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                        
                        
                        Text(
                            onboardingVM
                                .texts[onboardingVM.currentTextIndex]
                        )
                            .font(
                                .custom(
                                    "Gilroy-Regular",
                                    size: geometry.size.width * 0.045,
                                    relativeTo: .subheadline
                                )
                            )
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.7))
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.bgView)
                            .padding(.bottom, 4)
                    }
                    .padding(.vertical)
                    
                    
                    Spacer()
                    
                    // Next button
                    Button {
                        onboardingVM.nextText()
                    } label: {
                        Image("nextBtn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.5333333333)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    OnboardingView()
}
