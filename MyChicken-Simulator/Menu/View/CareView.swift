import SwiftUI

struct CareView: View {
    @ObservedObject var menuVM: MenuViewModel
    
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    ShadowTextView(
                        text: "CARE",
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
                        Spacer()
                        
                        Button {
                            menuVM.isCareMenuOpened = false
                        } label: {
                            Image("closeBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width * 0.15)
                        }
                    }
                }
                
                HStack {
                    ForEach(menuVM.cares, id: \.self) { care in
                        Button {
                            menuVM.selectedCare = care
                        } label: {
                            Image(care == menuVM.selectedCare ? care + "Tapped" : care)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
                
                Button {
                    menuVM.careForChicken() 
                } label: {
                    Image(
                        menuVM.selectedCare != nil ? "chooseBtnActive" : "chooseBtnUnactive"
                    )
                        .resizable()
                        .scaledToFit()
                        .frame(width: width * 0.4358974359)
                }
                .disabled(menuVM.selectedCare == nil)
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
        }
    }
}

#Preview {
    @StateObject var menuVM = MenuViewModel()
    CareView(menuVM: menuVM)
}
