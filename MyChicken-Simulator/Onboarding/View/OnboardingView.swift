import SwiftUI

struct OnboardingView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel()
    @Binding var hasSeenOnboarding: Bool
    
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
                            hasSeenOnboarding = true
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
                            outlineColor: .black,
                            outlineWidth: 1,
                            shadowColor: .black,
                            shadowOffset: CGSize(width: 1.97, height: 1.97),
                            shadowOpacity: 1 
                        )
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                        
                        
                        Text(
                            onboardingVM
                                .texts[onboardingVM.currentTextIndex]
                        )
                            .foregroundStyle(.black)
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
                        onboardingVM
                            .nextText(hasSeenOnboarding: &hasSeenOnboarding)
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
    OnboardingView(hasSeenOnboarding: .constant(false))
}
