//
//  ViewController.swift
//  FavoriteGames
//
//  Created by Robert Garza on 6/8/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        GiantBombAPI.sharedSession.getGameData("metroid") { description in
            
            self.webView.loadHTMLString(description, baseURL: nil)
            print(description)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

