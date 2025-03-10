import SwiftUI

struct CatchTheGrainIntroduceView: View {
    @ObservedObject var vm: CatchTheGrainViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("bg1")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image("backBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width * 0.1538461538)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image("warning")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.2)
                        
                        ShadowTextView(
                            text: "THE GOAL OF THE GAME",
                            fontName: "Gilroy-Heavy",
                            fontSize: width * 0.11,
                            textColor: Color(red: 0.722, green: 0.055, blue: 0.306),
                            outlineColor: .black,
                            outlineWidth: 1,
                            shadowColor: .black,
                            shadowOffset: CGSize(width: 1.97, height: 1.97),
                            shadowOpacity: 1
                        )
                        .padding(.vertical)
                        
                        Text("Catch as many grains falling from above as possible within a limited time to earn golden eggs.")
                            .font(.custom("Gilroy-Regular", size: width * 0.045))
                            .frame(width: width * 0.75)
                    }
                    .padding()
                    .padding(.vertical)
                    .frame(width: width * 0.9)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.7))
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.bgView)
                            .padding(.bottom, 4)
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        
                    } label: {
                        Image("nextBtn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.5333333333)
                    }
                }
                .frame(width: width * 0.9)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    @StateObject var vm = CatchTheGrainViewModel()
    CatchTheGrainIntroduceView(vm: vm)
}
