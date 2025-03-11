import SwiftUI

struct SurpriseEggOopsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var gameVM: SurpriseEggViewModel
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image("closeBtn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.13)
                    }
                }
                ShadowTextView(
                    text: "OOPS!",
                    fontName: "Gilroy-Heavy",
                    fontSize: width * 0.09,
                    textColor: Color(red: 0.722, green: 0.055, blue: 0.306),
                    outlineColor: .black,
                    outlineWidth: 1,
                    shadowColor: .black,
                    shadowOffset: CGSize(width: 1.97, height: 1.97),
                    shadowOpacity: 1
                )
                
                Text("You have no more attempts for today.\nBut don't feel bad - you can try again later")
                    .font(.custom("Gilroy-Regular", size: width*0.04))
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
    @StateObject var gameVM = SurpriseEggViewModel()
    SurpriseEggOopsView(gameVM: gameVM)
}
