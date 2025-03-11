import Foundation

class TabViewSetting: ObservableObject {
    static let shared = TabViewSetting()
    
    private init() {}
    
    @Published var isTabViewHidden: Bool = false
    
    func hideTabview() {
        isTabViewHidden = true
    }
    
    func showTabview() {
        isTabViewHidden = false
    }
}
