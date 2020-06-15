//
//  StartGameVC.swift
//  NanoChallenge3
//
//  Created by Theofani on 11/06/20.
//  Copyright © 2020 Rahman Fadhil. All rights reserved.
//

import UIKit
import AVFoundation

// TODO: button clicked sound
class StartGameVC: UIViewController {
    
    @IBOutlet weak var buttonStart: UIButton!
    var audioPlayer: AVAudioPlayer!
    var buttonClick: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        playAudioFromProject()
        
    }
    
    func playAudioFromProject() {
        guard let url = Bundle.main.url(forResource: "game-bg-music", withExtension: "mp3") else {
            print("error to get the mp3 file")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("audio file error")
        }
        audioPlayer?.play()
        audioPlayer?.setVolume(0.3, fadeDuration: 0)
        audioPlayer?.numberOfLoops = -1
    }
    
    func buttonClicked(){
        guard let url = Bundle.main.url(forResource: "buttonClick", withExtension: "m4a") else {
            print("error to get the m4a file")
            return
        }

        do {
            buttonClick = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("audio file error")
        }
        buttonClick.play()
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        buttonClicked()
    }
}
