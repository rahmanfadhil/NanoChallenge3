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

// TODO: play background music.
// TODO: play a sound when a block collide with other block.
// TODO: play a sound when a block is selected.
// TODO: when a block touched the ground, end the game.
// TODO: rotate the screen 180 degree each time the player dropped a block.

class GameScene: SKScene, GameDelegate {
    
    var audioPlayer: AVAudioPlayer!
    
    // Score text
    private var scoreLabel = SKLabelNode(text: "Score: 0")
    
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
        
        // Score text
        // TODO: change text font to a nicer and playful font.
        scoreLabel.fontColor = UIColor.black
        scoreLabel.fontSize = 48
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 200)
        
        // Add physics body to the scene, prevent blocks from escaping the scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets.init(top: 300, left: 0, bottom: 0, right: 0)))
    }
    
    // Add a single block to the scene
    func addBlock(name: String, position: CGPoint) {
        // Create block sprite node
        let node = SKSpriteNode(imageNamed: name)
        
        // Position block randomly in the screen
        node.position = position
        
        // Minimize block size
        node.setScale(0.175)
        
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
                CGPoint(x: 0, y: width / 2),
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
        
        // Add display to screen
        addChild(node)
        
        // Register dropped block to blocks property
        blocks.append(node)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            audioSelectBrick()
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
            CGPoint(x: frame.midX - 200, y: frame.minY + 150),
            CGPoint(x: frame.midX, y: frame.minY + 150),
            CGPoint(x: frame.midX + 200, y: frame.minY + 150)
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
            node.setScale(0.175)
            
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
    
    override func update(_ currentTime: TimeInterval) {
        // Get all block distances
        let blockDistances = blocks.map { (node) in
            return node.frame.maxY
        }
        
        // Get the farthest distance and update the score
        if let farthest = blockDistances.max() {
            scoreLabel.text = "Score: \(Int(farthest.rounded()))"
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

            // When a block is dropped, re-display random block options to the screen
            displayBlockOptions()
        }
        audioPutBrick()
        
        // Remove the currently dragged node
        currentNode = nil
    }
    
    func setPlayerNames(player1: String, player2: String) {
        print(player1)
        print(player2)
    }
}
