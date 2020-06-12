//
//  PlayersNameVC.swift
//  NanoChallenge3
//
//  Created by Theofani on 11/06/20.
//  Copyright © 2020 Rahman Fadhil. All rights reserved.
//

import UIKit
import AVFoundation

// TODO: button clicked sound
class PlayersNameVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputPlayerLabel: UILabel!
    @IBOutlet weak var firstPlayerName: UITextField!
    @IBOutlet weak var secondPlayerName: UITextField!
    @IBOutlet weak var playGameButton: UIButton!
    
    var playButton: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playGameButton.isEnabled = false
        inputPlayerLabel.textColor = UIColor.white
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var firstPlayer: String = firstPlayerName.text!
        var secondPlayer: String = secondPlayerName.text!
        
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if textField == firstPlayerName {
            firstPlayer = updatedString!
        } else if textField == secondPlayerName {
            secondPlayer = updatedString!
        }
        
        if firstPlayer.isEmpty || secondPlayer.isEmpty {
            playGameButton.isEnabled = false
        } else {
            playGameButton.isEnabled = true
        }
        
        return true
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstPlayerName.resignFirstResponder()
        secondPlayerName.resignFirstResponder()
        return true
    }
    
    func playButtonClicked(){
        guard let url = Bundle.main.url(forResource: "buttonClick", withExtension: "m4a") else {
            print("error to get the m4a file")
            return
        }

        do {
            playButton = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("audio file error")
        }
        playButton.play()
    }

    @IBAction func playTapped(_ sender: UIButton) {
        playButtonClicked()
        performSegue(withIdentifier: "toGame", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameDelegate {
            vc.setPlayerNames(player1: firstPlayerName.text!, player2: secondPlayerName.text!)
        }
    }
}
