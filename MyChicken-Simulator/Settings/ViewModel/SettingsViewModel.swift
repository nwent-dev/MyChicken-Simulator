import Foundation

class SettingsViewModel: ObservableObject {
    @Published var isSoundOff: Bool = true
    
    func toggleSound() {
        isSoundOff.toggle()
    }
}
