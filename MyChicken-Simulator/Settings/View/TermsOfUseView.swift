import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        WebView(url: URL(string: "https://ya.ru")!)
    }
}

#Preview {
    TermsOfUseView()
}
