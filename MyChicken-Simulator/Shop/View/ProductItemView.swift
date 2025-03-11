import SwiftUI

struct ProductItemView: View {
    let image: String
    let price: Int
    let isBuyed: Bool
    let action: () -> Void
    
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: width * 0.2)
            
            HStack {
                Text("\(price)")
                    .font(.custom("Gilroy-Heavy", size: width*0.05))
                    .foregroundStyle(.black)
                Image("egg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width * 0.05)
            }
            
            Button {
                action()
            } label: {
                if isBuyed {
                    Image("purchasedBtn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width * 0.24)
                } else {
                    Image("buyBtn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width * 0.24)
                }
            }
        }
        .padding()
        .frame(width: width * 0.43, height: height * 0.21)
        .background {
            RoundedRectangle(cornerRadius: 9)
                .fill(Color.bgView)
        }
    }
}

#Preview {
    ProductItemView(image: "glasses", price: 30, isBuyed: true) {
        print("hello")
    }
}
