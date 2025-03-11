import SwiftUI

struct HomeView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var selectedTab: Int = 1
    @StateObject private var menuVM = MenuViewModel()
    var body: some View {
        if hasSeenOnboarding {
            OnboardingView()
        } else {
            TabView(selection: $selectedTab) {
                MenuView(menuVM: menuVM)
                    .tag(1)
                
                GameView(menuVM: menuVM)
                    .tag(2)
                
                ShopView()
                    .tag(3)
                
                SettingsView()
                    .tag(4)
            }
            .overlay(alignment: .bottom) {
                CustomTabView(tabSelection: $selectedTab)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
}
