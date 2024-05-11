//
//  GameOverExt.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//

import SpriteKit

extension GameOver {
    func createBGNodes() {
        for i in 0...2 {
            let bgNode = SKSpriteNode(imageNamed: "background")
            bgNode.name = "background"
            bgNode.anchorPoint = .zero
            bgNode.position = CGPoint(x: CGFloat(i) * bgNode.frame.width, y: 0.0)
            bgNode.zPosition = -1.0
            addChild(bgNode)
        }
    }
    
    func createGroundNodes() {
        for i in 0...2 {
            let groundNode = SKSpriteNode(imageNamed: "ground")
            groundNode.name = "ground"
            groundNode.anchorPoint = .zero
            groundNode.zPosition = 1.0
            groundNode.position =  CGPoint(x: CGFloat(i) * groundNode.frame.width, y: 0.0)
            addChild(groundNode)
        }
    }
    
    func moveNodes() {
        enumerateChildNodes(withName: "background") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.x -= 8.0
            
            if node.position.x < -self.frame.width {
                node.position.x += node.frame.width * 2.0
            }
            
        }
        
        enumerateChildNodes(withName: "ground") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.x -= 8.0
            
            if node.position.x < -self.frame.width {
                node.position.x += node.frame.width * 2.0
            }
            
        }
    }
    
    func createNode() {
        // ganti sama calories
        let calories = SKSpriteNode(imageNamed: "calories")
        calories.zPosition = 10.0
        calories.position = CGPoint(x: size.width/2.0 - 150.0, y: size.height/2.0 + calories.frame.height/2.0)
        addChild(calories)
        
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        
        let fullScale = SKAction.sequence([scaleUp, scaleDown])
        calories.run(.repeatForever(fullScale))
        
        let caloriesLbl = SKLabelNode(fontNamed: "Krungthep")
        caloriesLbl.text = String(format: "%.0f cal", CaloriesGenerator.sharedInstance.getScore())
        caloriesLbl.fontColor = UIColor.black

        caloriesLbl.fontSize = 80.0
        caloriesLbl.zPosition = 10.0
        caloriesLbl.position = CGPoint(x: size.width/2.0 + 100.0, y: size.height/2.0 + caloriesLbl.frame.height/2.0)
        addChild(caloriesLbl)
        
        calories.run(.repeatForever(fullScale))
        
    }
}

