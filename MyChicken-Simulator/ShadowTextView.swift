import SwiftUI

struct ShadowTextView: View {
    var text: String
    var fontName: String
    var fontSize: CGFloat
    var textColor: Color
    var outlineColor: Color
    var outlineWidth: CGFloat
    var shadowColor: Color
    var shadowOffset: CGSize
    var shadowOpacity: Double

    var body: some View {
        ZStack {
            Text(text)
                .font(.custom(fontName, size: fontSize))
                .foregroundColor(outlineColor)
                .offset(x: -outlineWidth, y: -outlineWidth)

            Text(text)
                .font(.custom(fontName, size: fontSize))
                .foregroundColor(outlineColor)
                .offset(x: outlineWidth, y: -outlineWidth)

            Text(text)
                .font(.custom(fontName, size: fontSize))
                .foregroundColor(outlineColor)
                .offset(x: -outlineWidth, y: outlineWidth)

            Text(text)
                .font(.custom(fontName, size: fontSize))
                .foregroundColor(outlineColor)
                .offset(x: outlineWidth, y: outlineWidth)

            // main text 
            Text(text)
                .font(
                    .custom(fontName, size: fontSize, relativeTo: .largeTitle)
                )
                .foregroundColor(textColor)
                .shadow(color: shadowColor.opacity(shadowOpacity),
                        radius: 0,
                        x: shadowOffset.width,
                        y: shadowOffset.height)
        }
        .multilineTextAlignment(.center)
    }
}

extension View {
    func stroke(color: Color, width: CGFloat = 1) -> some View {
        modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
}

struct StrokeModifier: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue

    func body(content: Content) -> some View {
        if strokeSize > 0 {
            appliedStrokeBackground(content: content)
        } else {
            content
        }
    }

    private func appliedStrokeBackground(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background(
                Rectangle()
                    .foregroundColor(strokeColor)
                    .mask(alignment: .center) {
                        mask(content: content)
                    }
            )
    }

    func mask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            if let resolvedView = context.resolveSymbol(id: id) {
                context.draw(resolvedView, at: .init(x: size.width/2, y: size.height/2))
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}
