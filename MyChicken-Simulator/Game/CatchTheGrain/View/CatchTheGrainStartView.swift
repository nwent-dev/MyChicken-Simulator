import SwiftUI

struct CatchTheGrainStartView: View {
    
    @StateObject var vm = CatchTheGrainViewModel()
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
                    
                    ShadowTextView(
                        text: "CATCH THE GRAIN",
                        fontName: "Gilroy-Heavy",
                        fontSize: width * 0.18,
                        textColor: Color(red: 0.722, green: 0.055, blue: 0.306),
                        outlineColor: .black,
                        outlineWidth: 1,
                        shadowColor: .black,
                        shadowOffset: CGSize(width: 1.97, height: 1.97),
                        shadowOpacity: 1
                    )
                    
                    Spacer()
                    
                    NavigationLink {
                        CatchTheGrainIntroduceView(vm: vm)
                    } label: {
                        Image("playBtn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.5333333333)
                    }
                }
                .frame(width: width*0.9)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    CatchTheGrainStartView()
}
