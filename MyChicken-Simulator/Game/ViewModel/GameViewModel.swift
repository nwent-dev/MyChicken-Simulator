import Foundation

class GameViewModel: ObservableObject {
    @Published var isCatchTheGrainOpened: Bool = false
    @Published var isSupriseEggOpened: Bool = false
}
