import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        WebView(url: URL(string: "https://ya.ru")!)
    }
}

#Preview {
    PrivacyPolicyView()
}
