import SwiftUI
import SpriteKit
import AVFoundation

class ContentViewModel: ObservableObject {

    var audioPlayer: AVAudioPlayer?
    
    init() {
        loadMusic()
    }
    
    // load the sound file
    func loadMusic() {
        if let soundURL = Bundle.main.url(forResource: "FeverBeat", withExtension: "caf") {
            do {
                // initialize the audio player
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print("Error loading sound: \(error.localizedDescription)")
            }
        }
    }
    
    // play the sound
    func playMusic() {
        self.audioPlayer?.volume = 0.2
        // play sound on repeat
        self.audioPlayer?.numberOfLoops = -1 
        self.audioPlayer?.play()
    }
}
@main
struct CyberHeroApp: App {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some Scene {
        WindowGroup {
            
            GeometryReader { geometry in
                let size = geometry.size
                ZStack {
                    SpriteView(scene: IntroductionScene(size: size))
                        .frame(width: size.width, height: size.height)
                }
                .onAppear {
                    viewModel.playMusic()
                }
                .ignoresSafeArea()
            }
        }
           }
}
