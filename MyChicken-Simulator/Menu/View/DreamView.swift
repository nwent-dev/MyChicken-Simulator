import SwiftUI

struct DreamView: View {
    @ObservedObject var menuVM: MenuViewModel
    
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            if menuVM.isSleeping {
                VStack {
                    ShadowTextView(
                        text: "THE CHICKEN IS SLEEPING!",
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
                        Text("\(menuVM.sleepMinutes)")
                            .padding()
                            .padding(.horizontal)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.7))
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .padding(.bottom, 4)
                            }
                        Text(":")
                            .foregroundStyle(.white)
                        Text("\(menuVM.sleepSeconds)")
                            .padding()
                            .padding(.horizontal)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.7))
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .padding(.bottom, 4)
                            }
                            
                    }
                    .font(.custom("Gilroy-Heavy", size: width*0.1))
                    .foregroundStyle(.black)
                    
                    Button {
                        menuVM.stopSleepTimer()
                    } label: {
                        Image("wakeUpBtn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.4358974359)
                    }
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
            } else {
                VStack {
                    ZStack {
                        ShadowTextView(
                            text: "DREAM",
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
                                menuVM.isDreamMenuOpen = false
                            } label: {
                                Image("closeBtn")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: width * 0.15)
                            }
                        }
                    }
                    
                    Text("Choose a time when the chicken wakes up")
                        .font(.custom("Gilroy-Regular", size: width*0.04))
                        .multilineTextAlignment(.center)
                        .frame(width: width * 0.6)
                    
                    HStack {
                        ForEach(menuVM.times.prefix(3), id: \.self) { time in
                            TimeBtn(image: time, menuVM: menuVM)
                        }
                    }
                    
                    HStack {
                        ForEach(menuVM.times.suffix(2), id: \.self) { time in
                            TimeBtn(image: time, menuVM: menuVM)
                        }
                    }
                    
                    Button {
                        menuVM.sleepChicken()
                    } label: {
                        Image(
                            menuVM.selectedTime != nil ? "chooseBtnActive" : "chooseBtnUnactive"
                        )
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.4358974359)
                    }
                    .disabled(menuVM.selectedTime == nil)
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
}

struct TimeBtn: View {
    let image: String
    @ObservedObject var menuVM: MenuViewModel
    
    var body: some View {
        Button {
            menuVM.selectedTime = image
        } label: {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.25)
        }
    }
}

#Preview {
    @StateObject var menuVM = MenuViewModel()
    DreamView(menuVM: menuVM)
}
