import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsVM = SettingsViewModel.shared
    
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("bg1")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    ShadowTextView(
                        text: "SETTINGS",
                        fontName: "Gilroy-Heavy",
                        fontSize: width * 0.12,
                        textColor: Color(red: 0.722, green: 0.055, blue: 0.306),
                        outlineColor: .black,
                        outlineWidth: 1,
                        shadowColor: .black,
                        shadowOffset: CGSize(width: 1.97, height: 1.97),
                        shadowOpacity: 1
                    )
                    
                    VStack {
                        Text("SOUND SETTINGS")
                            .font(.custom("Gilroy-Heavy", size: width * 0.07))
                            .foregroundStyle(.black)
                        
                        Button {
                            settingsVM.toggleSound()
                        } label: {
                            Image(settingsVM.isSoundOff ? "soundOff" :"soundOn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width * 0.25)
                        }
                    }
                    .padding()
                    .frame(width: width*0.9)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.7))
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.bgView)
                            .padding(.bottom, 4)
                    }
                    
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        Image("privacyPolicy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width*0.9)
                    }
                    
                    NavigationLink {
                        TermsOfUseView()
                    } label: {
                        Image("termsOfUse")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width*0.9)
                    }
                    
                    Spacer()
                }
                .frame(width: width * 0.9)
            }
        }
    }
}

#Preview {
    SettingsView()
}
