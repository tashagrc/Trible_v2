//
//  SKTAudio.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//


// play and stop music
import AVFoundation

private let SKTAudioInstance = SKTAudio()
class SKTAudio {
    var bgMusic: AVAudioPlayer?
    var soundEffect: AVAudioPlayer?
    
    
    static let keyMusic = "keyMusic"
    static var musicEnabled: Bool = {
        return !UserDefaults.standard.bool(forKey: keyMusic)
    } () {
        didSet {
            let value = !musicEnabled
            UserDefaults.standard.set(value, forKey: keyMusic)

        }
    }
    
    static func sharedInstance() -> SKTAudio {
        return SKTAudioInstance
    }
    
    func playBGMusic(_ fileNamed: String) {
        if !SKTAudio.musicEnabled {
            return
        }
        
        guard let url = Bundle.main.url(forResource: fileNamed, withExtension: nil) else {
            return
        }
        
        do {
            bgMusic = try AVAudioPlayer(contentsOf: url)
        }
        catch let error as NSError {
            bgMusic = nil
        }
        
        if let bgMusic = bgMusic {
            bgMusic.numberOfLoops = -1
            bgMusic.prepareToPlay()
            bgMusic.play()
        }
    }
    
    
    
    func playSoundEffect(_ fileNamed: String) {
        guard let url = Bundle.main.url(forResource: fileNamed, withExtension: nil) else {return}
        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            soundEffect = nil
        }
        
        if let soundEffect = soundEffect {
            soundEffect.numberOfLoops = 0
            soundEffect.prepareToPlay()
            soundEffect.play()
        }
    }
    
    
}
