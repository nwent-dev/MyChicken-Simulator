import SwiftUI

struct ProgressOverlayView: View {
    let image: String
    let fillColor: Color
    @Binding var progress: CGFloat

    var body: some View {
        ZStack {
            // Основное изображение (фон)
            Image(image)
                .resizable()
                .scaledToFit()
            
            // Прогресс-бар поверх, без лишних отступов
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
        .onTapGesture {
            // Клик для увеличения прогресса
            progress = progress < 1.0 ? progress + 0.1 : 0.0
        }
    }
}

#Preview {
    @State var progress: CGFloat = 0.97 //(0.26 - 0.97)
    ProgressOverlayView(image: "foodStatus", fillColor: .red, progress: $progress)
        .previewLayout(.sizeThatFits)
}
