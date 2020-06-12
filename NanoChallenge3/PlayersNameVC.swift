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
        inputPlayerLabel.textColor = UIColor.white
        if firstPlayerName.text?.isEmpty == true || secondPlayerName.text?.isEmpty == true{
                   playGameButton.isEnabled = false
                   playGameButton.imageView?.image = #imageLiteral(resourceName: "playNotActive")
        } else {
            playGameButton.isEnabled = true
        }
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
