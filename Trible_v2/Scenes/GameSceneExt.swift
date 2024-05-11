//
//  GameSceneExt.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//
import SpriteKit
import GameplayKit

// configuration

// extention bisa nambah sesuatu ke class tanpa harus punya akses ke class tsb
extension GameScene {
    func setupNodes() {
        createBG()
        createGround()
        spawnObstacles()
        createPlayer()
        setupCoin()
        spawnCoin()
        setupPhysics()
        setupLife()
//        setupScore()
        setupPause()
        setupControl()
        setupCamera()
    }
    
    func setupPhysics() {
        physicsWorld.contactDelegate = self
    }
    
    func createBG() {
        // GANTI INI KALO MAU GANTI BACKGROUND YG PALING BELAKANG
        // ini looping sampe 3 instance aja agar cover screen width, kalo cuma 2 ga cukup
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "background")
            bg.anchorPoint = .zero // defaultnya 0
            bg.name = "BG"
            
            // default position itu 0, mau diganti agar default positionnya sesuai frame
            // posisi awal backgroundnya, ini bikin 3 background jejer2 secara horizontal
            bg.position = CGPoint(x: CGFloat(i) * bg.frame.width, y: 0.0)
            bg.zPosition = -1.0
            addChild(bg)
        }
        
    }
    
    func createGround() {
        for i in 0...2 {
            // ganti ini kalo mau ganti tanahnya
            ground = SKSpriteNode(imageNamed: "ground")
            ground.name = "Ground"
            ground.anchorPoint = .zero
            ground.zPosition = 1.0
            // ground memenuhi layar secara horizontal dgn posisi di bawah
            ground.position = CGPoint(x: CGFloat(i) * ground.frame.width, y: 0.0)
            
            // add SKPhysicsBody
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            // artinya ground statik, ga dipengaruhi collision
            ground.physicsBody!.isDynamic = false
            // ga terpengaruh gravity, biasa dipake di static object
            ground.physicsBody!.affectedByGravity = false
            
            // pembeda dgn object lain
            ground.physicsBody!.categoryBitMask = PhysicsCategory.Ground
            
            addChild(ground)
        }
    }
    
    func createPlayer() {
        // ganti ini kalo mau ganti playernya
        player = SKSpriteNode(imageNamed: "person-1")
        player.name = "Player"
        player.zPosition = 5.0
        player.setScale(0.7)
        // lokasi horizontal tengah agak kiri
        player.position = CGPoint(x: frame.width/2.0 - 100.0, y: ground.frame.height + player.frame.height/2.0)
        
        // player physics
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.restitution = 0.0 // bounciness, ini berarti ga bounce
        player.physicsBody!.categoryBitMask = PhysicsCategory.Player
        player.physicsBody!.contactTestBitMask = PhysicsCategory.Block | PhysicsCategory.Obstacle | PhysicsCategory.Coin
        player.physicsBody!.allowsRotation = false
    
        
        // get position of player for jumping
        playerPosY = player.position.y

        // kasih animasi
        var texturesRun: [SKTexture] = []
        for i in 0...4 {
            texturesRun.append(SKTexture(imageNamed: "person-\(i)"))
        }
        
        // repeat animation forever
        player.run(.repeatForever(.animate(with: texturesRun, timePerFrame: 0.083)))
        
        
        addChild(player)
    }
    
    //  bikin biar ada view pointnya
    func setupCamera() {
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
    }
    
    // gerakin kamera jd horizontal scroll
    func moveCamera() {
        // rumus s = v * t buat itung seberapa banyak camera harus gerak
        let amountToMove = CGPoint(x: cameraMovePointPerSecond * CGFloat(dt), y: 0.0)
        
        // gerakin camera position sesuai amount of move
        // cameraNode.position = CGPoint(x: cameraNode.position.x + amountToMove.x, y: cameraNode.position.y + amountToMove.y)
        
        // lihat file CGPoint+Ext, += sudah dioverload
        cameraNode.position += amountToMove
        
        // biar backgroundnya infinity, tapi masih blm smooth ada jeda hitamnya
        enumerateChildNodes(withName: "BG") { (node, _) in
            let node = node as! SKSpriteNode
            if node.position.x + node.frame.width < self.cameraRect.origin.x {
                node.position = CGPoint(x: node.position.x + node.frame.width * 2.0, y: node.position.y)
            }
            
        }
        // biar groundnya infinity, tapi masih blm smooth ada jeda hitamnya
        enumerateChildNodes(withName: "Ground") { (node, _) in
            let node = node as! SKSpriteNode
            if node.position.x + node.frame.width < self.cameraRect.origin.x {
                node.position = CGPoint(x: node.position.x + node.frame.width * 2.0, y: node.position.y)
            }
            
        }
    }
    
    func movePlayer() {
        let amountToMove = cameraMovePointPerSecond * CGFloat(dt)
        player.position.x += amountToMove
    }
    
    func setupObstacles() {
        // ganti ini kalo mau ganti asset obstacles
        
        // ini block yg kotak
        for i in 1...2 {
            let spriteBlock = SKSpriteNode(imageNamed: "block-\(i)")
            spriteBlock.name = "Block"
            spriteBlock.setScale(0.6)
            obstacles.append(spriteBlock)
        }
        
        // ini yg api di bawah
        let spriteFire = SKSpriteNode(imageNamed: "obstacle-2-1")
        spriteFire.name = "Obstacle"
        spriteFire.setScale(0.6)
        obstacles.append(spriteFire)
        
        // kasih animasi
        var texturesFire: [SKTexture] = []
        for i in 1...3 {
            texturesFire.append(SKTexture(imageNamed: "obstacle-2-\(i)"))
        }
        // repeat animation forever
        spriteFire.run(.repeatForever(.animate(with: texturesFire, timePerFrame: 0.083)))
        
        // ini kotak duri2 yg di atas
        let spriteThorns = SKSpriteNode(imageNamed: "obstacle-1")
        spriteThorns.name = "ObstacleFloat"
        spriteThorns.setScale(0.6)
        obstacles.append(spriteThorns)
        // bikin jadi random
        
        let index = Int(arc4random_uniform(UInt32(obstacles.count - 1)))
        let sprite = obstacles[index].copy() as! SKSpriteNode
        sprite.zPosition = 5.0
        sprite.setScale(0.6)
        
        // ini posisi obstacle yg melayang
        if sprite.name == "ObstacleFloat" {
            sprite.position = CGPoint(x: cameraRect.maxX + sprite.frame.width/2.0, y: ground.frame.height + sprite.frame.height/2.0 + 200.0)
        } // ini posisi obstacle yg di tanah
        else {
            sprite.position = CGPoint(x: cameraRect.maxX + sprite.frame.width/2.0, y: ground.frame.height + sprite.frame.height/2.0)
        }
        
        
        
        // add physics
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody!.affectedByGravity = false
        sprite.physicsBody!.isDynamic = false
        
        if sprite.name == "Block" {
            sprite.physicsBody!.categoryBitMask = PhysicsCategory.Block
        }
        else {
            sprite.physicsBody!.categoryBitMask = PhysicsCategory.Obstacle
        }
        // contact itu bersentuhan aja, kalo collision itu tabrakan sampe nyrungsep
        sprite.physicsBody!.contactTestBitMask = PhysicsCategory.Player
        
        addChild(sprite)
        
        // delete ketika obstacles udah ga dipake
        sprite.run(.sequence([
            .wait(forDuration: 10.0),
            .removeFromParent()
        ]))
    }
    
    // ini obstacle selain block
    func spawnObstacles() {
        
        let random = Double(CGFloat.random(min: 5, max: isTime))
        let spawn = SKAction.repeatForever(.sequence([
            .wait(forDuration: random),
            .run { [weak self] in
                self?.setupObstacles()
            }]))
        run(.sequence([.wait(forDuration: 5), spawn]))
        
        
        // makin lama main, makin cepat geraknya
        run(.repeatForever(.sequence([
            .wait(forDuration: 5.0),
            .run {
                self.isTime -= 0.01
                
                if self.isTime <= 5 {
                    self.isTime = 5
                }
            }])))
    }
    
    func setupCoin() {
        coin = SKSpriteNode(imageNamed: "Apple-1")
        coin.name = "Coin"
        coin.zPosition = 20.0
        coin.setScale(0.7)
        
        // set coin size and loc
        let coinHeight = coin.frame.height
        let random = CGFloat.random(min: -coinHeight, max: coinHeight*2.0)
        coin.position = CGPoint(x: cameraRect.maxX + coin.frame.width, y: size.height/2.0 + random)
        
        // physics coin
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width / 2.0)
        coin.physicsBody!.affectedByGravity = false
        coin.physicsBody!.categoryBitMask = PhysicsCategory.Coin
        coin.physicsBody!.contactTestBitMask = PhysicsCategory.Player
        
        
        addChild(coin)
        coin.run(.sequence([
            .wait(forDuration: 15.0),
            .run {
                self.coin.removeFromParent()
            }
        ]))
        
        
        // coin ada animasinya, ini set animasi coin
        var textures: [SKTexture] = []
        for i in 1...16 {
            textures.append(SKTexture(imageNamed: "Apple-\(i)"))
        }
        // repeat animation forever
        coin.run(.repeatForever(.animate(with: textures, timePerFrame: 0.083)))

    }
    
    func spawnCoin() {
        let random = CGFloat.random(min: 2.5, max: 6.0)
        run(.repeatForever(.sequence([
            .wait(forDuration: random),
            .run { [weak self] in
                self?.setupCoin()
            }
        ])))
    }

    // grafik life
    func setupLife() {
        // ambil gambar
        let node1 = SKSpriteNode(imageNamed: "life-on")
        let node2 = SKSpriteNode(imageNamed: "life-on")
        let node3 = SKSpriteNode(imageNamed: "life-on")
        // posisi
        setupLifePos(node1, i: 1.0, j: 0.0)
        setupLifePos(node2, i: 2.0, j: 8.0)
        setupLifePos(node3, i: 3.0, j: 16.0)
        
        lifeNodes.append(node1)
        lifeNodes.append(node2)
        lifeNodes.append(node3)
    }
    
    func setupLifePos(_ node: SKSpriteNode, i: CGFloat, j: CGFloat) {
        let width = playableRect.width
        let height = playableRect.height
        
        print(width)
        print(height)
        
        node.setScale(0.4)
        node.zPosition = 50.0
        
        // ganti position
        node.position = CGPoint(x: -height/3 + node.frame.width * CGFloat(i) + CGFloat(j) - 15.0, y: width/3 - node.frame.height)


        cameraNode.addChild(node)
    }
    
    // score graphic
//    func setupScore() {
//        // icon
//        coinIcon = SKSpriteNode(imageNamed: "Apple-1")
//        // ukuran coinnya
//        coinIcon.setScale(0.5)
//        coinIcon.zPosition = 50.0
//        coinIcon.position = CGPoint(x: -playableRect.width/2.0 + coinIcon.frame.width, y: playableRect.height/2.0 - lifeNodes[0].frame.height - coinIcon.frame.height/2.0)
//        cameraNode.addChild(coinIcon)
//
//         add score label
//        scoreLbl.text = "\(numScore)"
//        scoreLbl.fontSize = 60.0
//        scoreLbl.horizontalAlignmentMode = .left
//        scoreLbl.verticalAlignmentMode = .top
//        scoreLbl.zPosition = 50.0
//        scoreLbl.position = CGPoint(x: -playableRect.width/2.0 + coinIcon.frame.width*2.0 - 10.0, y: coinIcon.position.y + coinIcon.frame.height/2.0 - 8.0)
//        cameraNode.addChild(scoreLbl)
//    }
    
    // pause feature
    func setupPause() {
        pauseNode = SKSpriteNode(imageNamed: "pause")
        pauseNode.setScale(0.4)
        pauseNode.zPosition = 50.0
        pauseNode.name = "pause"
        pauseNode.position = CGPoint(x: playableRect.height/3.0 - pauseNode.frame.width, y: playableRect.width/3.0 - pauseNode.frame.height/2.0)
        cameraNode.addChild(pauseNode)
    }
    
    // create panel pop up when you clicked pause feature
    func createPanel() {
        cameraNode.addChild(containerNode)
        let panel = SKSpriteNode(imageNamed: "panel")
        panel.zPosition = 60.0
        panel.position = .zero
        containerNode.addChild(panel)
        
        let resume = SKSpriteNode(imageNamed: "resume")
        resume.zPosition = 70.0
        resume.name = "resume"
        resume.setScale(0.7)
        resume.position = CGPoint(x: -panel.frame.width/2.0 + resume.frame.width*1.5, y: 0.0)
        panel.addChild(resume)
        
        let quit = SKSpriteNode(imageNamed: "back")
        quit.zPosition = 70.0
        quit.name = "quit"
        quit.setScale(0.7)
        quit.position = CGPoint(x: panel.frame.width/2.0 - quit.frame.width*1.5, y: 0.0)
        panel.addChild(quit)
        
    }
    
    // tambahin control buat jump and squat
    func setupControl() {
        
        jumpArrow = SKSpriteNode(imageNamed: "arrowUp")
        jumpArrow.name = "jumpArrow"
        
        jumpArrow.zPosition = 50.0
        
        jumpArrow.position = CGPoint(x: playableRect.height/3 - jumpArrow.frame.width, y: -playableRect.width/3 + jumpArrow.frame.height/2.0)

        
        cameraNode.addChild(jumpArrow)
    }
    
    // cek kalo player udh keluar dari layar
    func boundCheckPlayer() {
        let bottomLeft = CGPoint(x: cameraRect.minX, y: cameraRect.minY)
        if player.position.x <= bottomLeft.x {
            player.position.x = bottomLeft.x
            lifeNodes.forEach( {
                $0.texture = SKTexture(imageNamed: "life-off")
            })
//            numScore = 0
//            scoreLbl.text = "\(numScore)"
            gameOver = true
        }
    }
    
    
    func reduceLife() {
        life -= 1
        if life <= 0 {
            life = 0
        }
        lifeNodes[life].texture = SKTexture(imageNamed: "life-off")
        if life <= 0 && !gameOver {
            gameOver = true
        }
    }
    
}
