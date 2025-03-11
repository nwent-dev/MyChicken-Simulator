import SwiftUI

struct FeedView: View {
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    @ObservedObject var menuVM: MenuViewModel
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                ZStack {
                    ShadowTextView(
                        text: "FEED",
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
                            menuVM.isFeedMenuOpen = false
                        } label: {
                            Image("closeBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width * 0.15)
                        }
                    }
                }
                
                LazyVGrid(columns: [GridItem(.fixed(width * 0.4)), GridItem(.fixed(width * 0.4))]) {
                    ForEach(menuVM.food, id: \.self) { nFood in
                        VStack{
                            Button {
                                menuVM.selectedFood = nFood
                            } label: {
                                Image(nFood.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: width * 0.4)
                            }
                            
                            HStack{
                                Text("\(nFood.price)")
                                    .font(.custom("Gilroy-Heavy", size: width*0.07))
                                Image("egg")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: width * 0.1)
                            }
                        }
                    }
                }
                
                Button {
                    menuVM.feedChicken()
                } label: {
                    Image(menuVM.selectedFood != nil ? "chooseBtnActive" : "chooseBtnUnactive")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width * 0.4358974359)
                }
                .disabled(menuVM.selectedFood == nil)
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
    FeedView(menuVM: menuVM)
}
