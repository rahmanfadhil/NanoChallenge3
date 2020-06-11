//
//  PlayersNameVC.swift
//  NanoChallenge3
//
//  Created by Theofani on 11/06/20.
//  Copyright © 2020 Rahman Fadhil. All rights reserved.
//

import UIKit

class PlayersNameVC: UIViewController {

    @IBOutlet weak var inputPlayerLabel: UILabel!
    @IBOutlet weak var firstPlayerName: UITextField!
    @IBOutlet weak var secondPlayerName: UITextField!
    @IBOutlet weak var playGameButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        inputPlayerLabel.textColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
