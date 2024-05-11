//
//  GameOver.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//

import SpriteKit

class GameOver: SKScene {
    override func didMove(to view: SKView) {
        createBGNodes()
        createGroundNodes()
        createNode()
        
        run(.sequence([
            .wait(forDuration: 5.0),
            .run {
                let scene = MainMenu(size:self.size)
                scene.scaleMode = self.scaleMode
                self.view!.presentScene(scene, transition: .doorsCloseVertical(withDuration: 0.5))
            }]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveNodes()
    }
}

