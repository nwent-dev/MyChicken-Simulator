import Foundation
import AVFoundation

class SettingsViewModel: ObservableObject {
    static let shared = SettingsViewModel() // Singleton
    
    @Published var isSoundOff: Bool {
        didSet {
            UserDefaults.standard.set(isSoundOff, forKey: "isSoundOff")
            updateSoundState()
        }
    }
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?
    
    private init() {
        self.isSoundOff = UserDefaults.standard.bool(forKey: "isSoundOff")
        setupBackgroundMusic()
        updateSoundState()
    }
    
    func toggleSound() {
        isSoundOff.toggle()
    }
    
    private func setupBackgroundMusic() {
        if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.prepareToPlay()
            } catch {
                print("Error loading background music: \(error.localizedDescription)")
            }
        }
    }
    
    func playBackgroundMusic() {
        if !isSoundOff {
            backgroundMusicPlayer?.play()
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
    
    func playSoundEffect(named soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file not found: \(soundName)")
            return
        }
        
        do {
            if !isSoundOff {
                soundEffectPlayer = try AVAudioPlayer(contentsOf: soundURL)
                soundEffectPlayer?.play()
            }
        } catch {
            print("Error playing sound effect: \(error.localizedDescription)")
        }
    }
    
    private func updateSoundState() {
        if isSoundOff {
            stopBackgroundMusic()
        } else {
            playBackgroundMusic()
        }
    }
}
