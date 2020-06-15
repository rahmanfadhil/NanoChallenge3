//
//  GameScene.swift
//  NanoChallenge3
//
//  Created by Rahman Fadhil on 10/06/20.
//  Copyright © 2020 Rahman Fadhil. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

// TODO: play a sound when a block collide with other block.
// TODO: when a block touched the ground, end the game.
// TODO: rotate the screen 180 degree each time the player dropped a block.
// TODO: delay screen when change player.
// TODO: finish screen with tower image.
// TODO: display player names.
// TODO: move camera.
// TODO: button clicked sound

struct PhysicsCategory {
    static let scene: UInt32 = 0b1
    static let block: UInt32 = 0b10
}

class GameScene: SKScene, GameDelegate {
    
    var finishedGameSprites = [SKNode]()
    
    var isFinished = false
    
    var playerLabel: SKLabelNode?
    var playerOne: String!
    var playerTwo: String!
    var currentPlayer = 1
    
    var gameViewDelegate: GameViewController?
    
    var audioPlayer: AVAudioPlayer!
    
    var countdownEnd: Date?
    
    var score = 0
    
    // Countdown text
    private var countdownLabel: SKLabelNode!
    
    private var changePlayerLabel: SKLabelNode!
    
    // The block that is currently being dragged in the screen
    private var currentNode: SKSpriteNode?
    
    // Available block types, will be used for getting the image
    private var availableBlockTypes = [
        "square",
        "angle-1",
        "angle-2",
        "letterl-1",
        "letterl-2",
        "lettert-1",
        "lettert-2",
        "straight-1",
        "straight-2"
    ]
    
    var followCamera = [SKNode]()
    
    // List of all blocks that has been dropped to the scene
    private var blocks = [SKSpriteNode]()
    
    // List of all block options, the items will be changed each time the user dropped a new block.
    // Maximum length: 3
    private var blockOptions = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        // Set the background color to white
        // TODO: use a nicer background image.
        backgroundColor = SKColor.white
        
        // Display all available blocks for the user to drop
        displayBlockOptions()
        
        playerLabel = SKLabelNode(fontNamed: "Norwester-Regular")
        playerLabel?.text = "\(playerOne!)'S TURN"
        playerLabel?.fontSize = 42
        playerLabel?.fontColor = .black
        playerLabel?.position = CGPoint(x: frame.maxX - 175, y: 1630)
        addChild(playerLabel!)
        followCamera.append(playerLabel!)
        
        // Countdown text
        countdownLabel = camera?.childNode(withName: "countdownLabel") as? SKLabelNode
        countdownLabel.text = "0"
        
        // Change player text
        changePlayerLabel = camera?.childNode(withName: "changePlayerLabel") as? SKLabelNode
        changePlayerLabel.text = ""
        
        setCountdown()
        
        // Add physics body to the scene, prevent blocks from escaping the scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(828 / 2), y: 351, width: 828 * 2, height: 5040))
        physicsBody?.categoryBitMask = PhysicsCategory.scene
        physicsBody?.contactTestBitMask = PhysicsCategory.block
        
        physicsWorld.contactDelegate = self
    }
    
    func setPlayerName() {
        currentPlayer = currentPlayer == 1 ? 2 : 1
        let playerName = currentPlayer == 1 ? playerOne : playerTwo
        print(currentPlayer)
        playerLabel?.text = "\(playerName!)'S TURN"
    }
    
    func setCountdown() {
        let now = Date()
        countdownEnd = now.addingTimeInterval(10.0)
    }
    
    // Add a single block to the scene
    func addBlock(name: String, position: CGPoint) {
        // Create block sprite node
        let node = SKSpriteNode(imageNamed: name)
        node.color = UIColor.red
        node.colorBlendFactor = 0.4
        // Position block randomly in the screen
        node.position = position
        
        // Minimize block size
        node.setScale(0.3)
        
        // Set the anchor point of the block
        node.anchorPoint = CGPoint(x: 0, y: 0)
        
        // Initialize polygon path for PhysicsBody
        let path = CGMutablePath()
        
        // The width and hight of the image
        let width = Int(node.size.width.rounded())
        let height = Int(node.size.height.rounded())
        
        // Set the polygon path based on the block type
        switch (name) {
        case "square", "straight-1", "straight-2":
            path.addLines(between: [
                CGPoint(x: 0, y: 0),
                CGPoint(x: width, y: 0),
                CGPoint(x: width, y: height),
                CGPoint(x: 0, y: height),
                CGPoint(x: 0, y: 0),
            ])
        case "angle-1":
            path.addLines(between: [
                CGPoint(x: width / 2, y: height),
                CGPoint(x: width, y: height),
                CGPoint(x: width, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: width / 2),
                CGPoint(x: width / 2, y: height / 2),
                CGPoint(x: width / 2, y: height)
            ])
        case "angle-2":
            path.addLines(between: [
                CGPoint(x: 0, y: height),
                CGPoint(x: width / 2, y: height),
                CGPoint(x: width / 2, y: height / 2),
                CGPoint(x: width, y: height / 2),
                CGPoint(x: width, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: height)
            ])
        case "letterl-1":
            path.addLines(between: [
                CGPoint(x: 0, y: height),
                CGPoint(x: width / 2, y: height),
                CGPoint(x: width / 2, y: height / 3),
                CGPoint(x: width, y: height / 3),
                CGPoint(x: width, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: height)
            ])
        case "letterl-2":
            path.addLines(between: [
                CGPoint(x: 0, y: height),
                CGPoint(x: width / 3, y: height),
                CGPoint(x: width / 3, y: height / 2),
                CGPoint(x: width, y: height / 2),
                CGPoint(x: width, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: height)
            ])
        case "lettert-1":
            path.addLines(between: [
                CGPoint(x: 0, y: height),
                CGPoint(x: width, y: height),
                CGPoint(x: width, y: height / 2),
                CGPoint(x: (width / 3) * 2, y: height / 2),
                CGPoint(x: (width / 3) * 2, y: 0),
                CGPoint(x: (width / 3), y: 0),
                CGPoint(x: (width / 3), y: height / 2),
                CGPoint(x: 0, y: height / 2),
                CGPoint(x: 0, y: height)
            ])
        case "lettert-2":
            path.addLines(between: [
                CGPoint(x: width / 3, y: height),
                CGPoint(x: (width / 3) * 2, y: height),
                CGPoint(x: (width / 3) * 2, y: height / 2),
                CGPoint(x: width, y: height / 2),
                CGPoint(x: width, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: height / 2),
                CGPoint(x: width / 3, y: height / 2),
                CGPoint(x: width / 3, y: height)
            ])
        default:
            print("type invalid!")
        }

        // Close polygon path
        path.closeSubpath()
        
        // Add PhysicsBody to block sprite node
        node.physicsBody = SKPhysicsBody(polygonFrom: path)
        
        node.physicsBody?.categoryBitMask = PhysicsCategory.block
        node.physicsBody?.contactTestBitMask = PhysicsCategory.scene
        
        node.name = "block"
        
        // Add display to screen
        addChild(node)
        
        // Register dropped block to blocks property
        blocks.append(node)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)

            for node in touchedNodes.reversed() {
                if let name = node.name, availableBlockTypes.contains(name) {
                    // Copy selected block
                    guard let copiedNode = node.copy() as? SKSpriteNode else { return }
                    copiedNode.position = location
                    copiedNode.zPosition = 1
                    addChild(copiedNode)
                    
                    // Set currently dragged node
                    currentNode = copiedNode
                    
                    audioSelectBrick()
                }
                
                if node.name == "playAgainButton" {
                    playAgain()
                }
            }
        }
    }
    
    
    // Display all available blocks for the user to drop.
    // The item will changed each time the user dropped a new block.
    func displayBlockOptions() {
       
        // Remove previous block options from the screen
        if blockOptions.count > 0 {
            for block in blockOptions {
                block.removeFromParent()
            }
            blockOptions.removeAll()
        }
        
        // Shuffle all available block types, so that we can get a random block types.
        let blocks = availableBlockTypes.shuffled()
        
        
        // The positions of each block options. This value will never changed.
        
        let blockLocations = [
            CGPoint(x: camera!.frame.midX - 250, y: camera!.frame.minY - 700),
            CGPoint(x: camera!.frame.midX, y: camera!.frame.minY - 700),
            CGPoint(x: camera!.frame.midX + 250, y: camera!.frame.minY - 700)
        ]
        
        // Display each block options
        for i in 0 ..< blockLocations.count {
            // Block type
            let block = blocks[i]
            
            // Block location
            let location = blockLocations[i]
            
            // Initialize node
            let node = SKSpriteNode(imageNamed: block)
            node.position = location
            node.name = block
            node.setScale(0.3)
            node.color = UIColor.red
            node.colorBlendFactor = 0.5
            node.zPosition = 3
            // Add node to the scene
            addChild(node)
            
            // Add node to blockOptions property, so that we can remove it later.
            blockOptions.append(node)
            
        }
    }
    
    //Play the sound effects
    //When touch select a brick
    func audioSelectBrick(){
        guard let url = Bundle.main.url(forResource: "selectBrick", withExtension: "m4a") else {
            print("error to get the m4a file")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("audio file error")
        }
        audioPlayer?.play()
    }
    
    //When putting the brick
    func audioPutBrick(){
        guard let url = Bundle.main.url(forResource: "putBrick", withExtension: "m4a") else {
            print("error to get the m4a file")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("audio file error")
        }
        audioPlayer?.play()
    }
    
    //When bricks fall
    func audioFallBrick(){
        guard let url = Bundle.main.url(forResource: "putBrick", withExtension: "m4a") else {
            print("error to get the m4a file")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("audio file error")
        }
        audioPlayer?.play()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let timeLeft = countdownEnd!.timeIntervalSinceNow
        
        // Set countdown text
        countdownLabel.text = String(format: "%.1f", timeLeft)
        if !isFinished && timeLeft < 0 {
            changePlayer()
        }
        
        // Get all block distances farthest
        let maxBlockDistances = blocks.map { (node) in
            return node.frame.maxY
        }
        
        // Get the farthest distance and update the score
        if let farthest = maxBlockDistances.max() {
            let newScore = Int(farthest.rounded())
            
            if newScore > score {
                score = newScore
                
                if farthest > frame.midY {
                    print("naik!")
                    camera?.position.y += 50
                    
                    for node in followCamera {
                        node.position.y += 50
                    }
                    
                    for node in blockOptions {
                        node.position.y += 50
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = currentNode {
            let touchLocation = touch.location(in: self)
            node.position = touchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = currentNode {
            // Get touch location
            let touchLocation = touch.location(in: self)
            
            // Original node from parent
            node.removeFromParent()
            
            // Because the block node uses a different anchor point, we need to explicitly define the center of the block.
            let location = CGPoint(x: touchLocation.x - node.size.width / 2, y: touchLocation.y - node.size.height / 2)
            
            // Create a new block
            addBlock(name: node.name!, position: location)
        
            audioPutBrick()
        }
        
        // Remove the currently dragged node
        currentNode = nil
    }
    
    func setPlayerNames(player1: String, player2: String) {
        playerOne = player1
        playerTwo = player2
    }
    
    func changePlayer() {
        displayBlockOptions()
        setPlayerName()
        
        // Setup overlay
        let overlay = SKSpriteNode(imageNamed: "redOverlay")
        overlay.position = CGPoint(x: camera!.position.x, y: camera!.position.y)
        overlay.size = CGSize(width: 828, height: 2500)
        overlay.zPosition = 8
        addChild(overlay)
        
        // Change player text
        let changePlayerLabel = SKLabelNode(fontNamed: "GoldenDragonSolid")
        changePlayerLabel.text = "CHANGE PLAYER"
        changePlayerLabel.position = CGPoint(x: camera!.position.x, y: camera!.position.y)
        changePlayerLabel.zPosition = 9
        changePlayerLabel.fontSize = 86
        addChild(changePlayerLabel)
        
        // Player name text
        let playerName: String = currentPlayer == 1 ? playerOne : playerTwo
        let playerNameLabel = SKLabelNode(fontNamed: "Norwester-Regular")
        playerNameLabel.text = "\(playerName)'S TURN"
        playerNameLabel.zPosition = 9
        playerNameLabel.fontSize = 64
        playerNameLabel.position = CGPoint(x: camera!.position.x, y: camera!.position.y - 120)
        addChild(playerNameLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.gameViewDelegate?.rotateScreen()
            overlay.removeFromParent()
            changePlayerLabel.removeFromParent()
            playerNameLabel.removeFromParent()
        }
        
        setCountdown()
    }
    
    func finishGame() {
        for block in blocks {
            block.removeFromParent()
        }
        
        isFinished = true
        
        audioFinishGame()
        
        // Setup background
        guard let background = childNode(withName: "gameSceneBg") as? SKSpriteNode else { return }
        background.zPosition = 10
        background.alpha = 1
        
        // Setup overlay
        let overlay = SKSpriteNode(imageNamed: "blueOverlay")
        overlay.position = CGPoint(x: camera!.position.x, y: camera!.position.y)
        overlay.size = CGSize(width: 828, height: 1792)
        overlay.zPosition = 11
        addChild(overlay)
        
        let totalScore = Double(score) * 0.3
        
        print(score)
        print(totalScore)
        
        var towerImage: SKSpriteNode?
        
        if totalScore > 300 {
            var towerName: String = ""
            
            if 301...400 ~= totalScore {
                towerName = "300m-achieve"
            } else if 401...500 ~= totalScore {
                towerName = "400m-achieve"
            } else if 501...600 ~= totalScore {
                towerName = "500m-achieve"
            } else if 601...700 ~= totalScore {
                towerName = "600m-achieve"
            } else if 701...800 ~= totalScore {
                towerName = "700m-achieve"
            } else if 801...900 ~= totalScore {
                towerName = "800m-achieve"
            } else {
                towerName = "900m-achieve"
            }
            
            towerImage = SKSpriteNode(imageNamed: towerName)
            towerImage?.position = CGPoint(x: camera!.position.x, y: camera!.position.y)
            towerImage?.zPosition = 12
            addChild(towerImage!)
        }
        
        // Reached text
        let gameFinishedLabel = SKLabelNode(fontNamed: "Norwester-Regular")
        gameFinishedLabel.text = "YOU BOTH HAVE REACHED"
        gameFinishedLabel.position = CGPoint(x: camera!.position.x, y: camera!.position.y + 520)
        gameFinishedLabel.zPosition = 12
        gameFinishedLabel.fontSize = 48
        addChild(gameFinishedLabel)
        
        // Score text
        let totalScoreString = String(format: "%.1f", totalScore)
        let scoreLabel = SKLabelNode(fontNamed: "GoldenDragonSolid")
        scoreLabel.text = "\(totalScoreString)m"
        scoreLabel.zPosition = 12
        scoreLabel.fontSize = 100
        scoreLabel.position = CGPoint(x: camera!.position.x, y: camera!.position.y + 400)
        addChild(scoreLabel)
        
        let playAgainButton = SKSpriteNode(imageNamed: "playAgain")
        playAgainButton.position = CGPoint(x: camera!.position.x, y: camera!.position.y - 500)
        playAgainButton.zPosition = 12
        playAgainButton.name = "playAgainButton"
        addChild(playAgainButton)
        
        finishedGameSprites = [playAgainButton, scoreLabel, gameFinishedLabel, overlay]
        
        if let towerImage = towerImage {
            finishedGameSprites += [towerImage]
        }
        
        score = 0
    }
    
    func audioFinishGame() {
        guard let url = Bundle.main.url(forResource: "finishGame", withExtension: "mp3") else {
            print("error to get the mp3 file")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("audio file error")
        }
        audioPlayer?.play()
    }
    
    func playAgain() {
        isFinished = false
        physicsBody?.categoryBitMask = PhysicsCategory.scene
        setCountdown()
        for node in finishedGameSprites {
            node.removeFromParent()
        }
        
        guard let background = childNode(withName: "gameSceneBg") as? SKSpriteNode else { return }
        background.zPosition = -7
        background.alpha = 0.4
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsCategory.block | PhysicsCategory.scene {
            let ground = contact.bodyA.node?.name == "scene" ? contact.bodyA.node : contact.bodyB.node
            ground?.physicsBody?.categoryBitMask = 0b100
            finishGame()
        }
    }
}
