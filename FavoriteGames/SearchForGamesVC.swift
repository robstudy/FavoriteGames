//
//  SearchForGamesVC.swift
//  FavoriteGames
//
//  Created by Robert Garza on 6/13/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit

class SearchForGamesVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    private var retrievedArray: NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchForGames(sender: AnyObject) {
        let gameText = searchTextField.text
        GiantBombAPI.sharedSession.getGameData(gameText!, completion: { description in
            if description != [] {
                self.retrievedArray = description
                print(self.retrievedArray)
            } else {
                print("No data retreived")
                return
            }
        })
    }
    
}
