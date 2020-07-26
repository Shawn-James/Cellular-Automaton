// Copyright © 2020 Shawn James. All rights reserved.
// AudioPlayer.swift

import AVFoundation

class AudioPlayer {
    
    static var shared = AudioPlayer()
    
    var audioPlayer: AVAudioPlayer?

    func playSound(_ soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
