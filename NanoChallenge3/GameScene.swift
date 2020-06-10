//
//  GameScene.swift
//  NanoChallenge3
//
//  Created by Rahman Fadhil on 10/06/20.
//  Copyright © 2020 Rahman Fadhil. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var blockOne = SKSpriteNode(color: .blue, size: CGSize(width: 50.0, height: 150.0))
    private var blockTwo = SKSpriteNode(color: .blue, size: CGSize(width: 150.0, height: 50.0))
    private var blockThree = SKSpriteNode(color: .blue, size: CGSize(width: 50.0, height: 150.0))
    private var scoreLabel = SKLabelNode(text: "Score: 0")
    private var currentNode: SKNode?
    
    private var blocks = [SKNode]()
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        scoreLabel.fontColor = UIColor.black
        scoreLabel.fontSize = 48
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 200)
        addChild(scoreLabel)
        
        blockOne.position = CGPoint(x: frame.midX - 200, y: frame.minY + 150)
        blockOne.name = "tall"
        addChild(blockOne)

        blockTwo.position = CGPoint(x: frame.midX, y: frame.minY + 150)
        blockTwo.name = "wide"
        addChild(blockTwo)

        blockThree.position = CGPoint(x: frame.midX + 200, y: frame.minY + 150)
        blockThree.name = "tall"
        addChild(blockThree)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets.init(top: 300, left: 0, bottom: 0, right: 0)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)

            for node in touchedNodes.reversed() {
                if node.name == "tall" || node.name == "wide" {
                    let copiedNode = node.copy() as! SKSpriteNode
                    copiedNode.position = location

                    copiedNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.frame.size.width, height: node.frame.size.height))

                    copiedNode.physicsBody?.allowsRotation = false
                    copiedNode.physicsBody?.friction = 10
                    copiedNode.physicsBody?.restitution = 0
                    copiedNode.name = "blah"
                    addChild(copiedNode)
                    currentNode = copiedNode
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Get all block distances
        let blockDistances = blocks.map { (node) in
            return node.position.y
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
        if let node = currentNode {
            node.physicsBody?.allowsRotation = true
            blocks.append(node)
        }
        
        currentNode = nil
    }
}
