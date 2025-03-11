import SwiftUI

struct ProgressOverlayView: View {
    let image: String
    let fillColor: Color
    @Binding var progress: CGFloat

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
            
            Image("status")
                .resizable()
                .scaledToFit()
                .overlay(
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(fillColor)
                            .frame(width: geometry.size.width * progress)
                            .animation(.easeInOut(duration: 0.5), value: progress)
                    }
                    .mask(
                        Image("status")
                            .resizable()
                            .scaledToFit()
                    )
                )
        }
    }
}

#Preview {
    @State var progress: CGFloat = 0.97 //(0.26 - 0.97)
    ProgressOverlayView(image: "foodStatus", fillColor: .red, progress: $progress)
        .previewLayout(.sizeThatFits)
}
