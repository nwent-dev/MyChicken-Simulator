import SwiftUI

struct CustomTabView: View {
    
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    let tabBarItems: [(imageSelected: String, imageUnselected: String)] = [
        ("menuBtnTapped", "menuBtn"),
        ("gameBtnTapped", "gameBtn"),
        ("magazineBtnTapped", "magazineBtn"),
        ("settingsBtnTapped", "settingsBtn")
    ]
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(0..<4) { index in
                    Button {
                        tabSelection = index + 1
                    } label: {
                        Image(index+1==tabSelection ? tabBarItems[index].imageSelected : tabBarItems[index].imageUnselected)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.18)
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               height: UIScreen.main.bounds.height * 0.09)
        .padding(.bottom, UIScreen.main.bounds.height * 0.04)
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(tabSelection: .constant(1))
            .previewLayout(.sizeThatFits)
            .padding(.vertical)
    }
}
