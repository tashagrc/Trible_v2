//
//  MainMenu.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//

import SpriteKit

class MainMenu: SKScene {
    // properties
    var containerNode: SKSpriteNode!
    
    let audioManager = SKTAudio.sharedInstance()
    
    
    // system
    override func didMove(to view: SKView) {
        setupBG()
        setupGrounds()
        setupNodes()
        
        audioManager.playBGMusic("backgroundMusic.mp3")
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveGrounds()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // hanya dijalankan kalo ada touch
        guard let touch = touches.first else {
            return
        }
        // tentukan lokasi touch
        let node = atPoint(touch.location(in: self))
        

        if node.name == "play" {
            let scene = GameScene(size: size)
            scene.scaleMode = scaleMode
            view!.presentScene(scene, transition: .doorsOpenVertical(withDuration: 0.3))
        }
        else if node.name == "highscore" {
            setupPanel()
        }
        else if node.name == "container" {
            containerNode.removeFromParent()
        }
        
    }
    
}
