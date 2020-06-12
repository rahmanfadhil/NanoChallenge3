//
//  PlayersNameVC.swift
//  NanoChallenge3
//
//  Created by Theofani on 11/06/20.
//  Copyright © 2020 Rahman Fadhil. All rights reserved.
//

import UIKit

class PlayersNameVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputPlayerLabel: UILabel!
    @IBOutlet weak var firstPlayerName: UITextField!
    @IBOutlet weak var secondPlayerName: UITextField!
    @IBOutlet weak var playGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playGameButton.isEnabled = false
        inputPlayerLabel.textColor = UIColor.white
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var firstPlayer: String = firstPlayerName.text!
        var secondPlayer: String = secondPlayerName.text!
        
        if textField == firstPlayerName {
            firstPlayer = string
        } else if textField == secondPlayerName {
            secondPlayer = string
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

    @IBAction func playTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toGame", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameDelegate {
            vc.setPlayerNames(player1: firstPlayerName.text!, player2: secondPlayerName.text!)
        }
    }
}
