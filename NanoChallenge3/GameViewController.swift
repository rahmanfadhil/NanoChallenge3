//
//  GameViewController.swift
//  NanoChallenge3
//
//  Created by Rahman Fadhil on 10/06/20.
//  Copyright © 2020 Rahman Fadhil. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol GameDelegate {
    func setPlayerNames(player1: String, player2: String)
}

class GameViewController: UIViewController, GameDelegate {
    
    var isRotated = false
    
    var player1: String?
    var player2: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                if let player1 = player1, let player2 = player2 {
                    scene.setPlayerNames(player1: player1, player2: player2)
                }
                
                scene.gameViewDelegate = self
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setPlayerNames(player1: String, player2: String) {
        self.player1 = player1
        self.player2 = player2
    }
    
    func loose() {
        print("loose!")
    }
    
    // Rotate screen 180 degree
    func rotateScreen() {
        view.transform = view.transform.rotated(by: .pi)
    }
}
