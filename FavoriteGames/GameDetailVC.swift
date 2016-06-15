//
//  GameDetalVC.swift
//  FavoriteGames
//
//  Created by Robert Garza on 6/15/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit
import CoreData

class GameDetailVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var gameDeckText: UITextView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var goToSiteButton: UIButton!
    @IBOutlet weak var detailView: UIWebView!
    var gameData: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Configure View Controller
    
    private func configureViewController() {
        titleBar.title = gameData.name
        goToSiteButton.layer.borderColor = UIColor.blackColor().CGColor
        goToSiteButton.layer.borderWidth = 2.0
        goToSiteButton.layer.cornerRadius = 8.0
        gameImage.image = UIImage(data: gameData.thumbnail!)
        gameDeckText.text = gameData.deck
        detailView.layer.borderColor = UIColor.blackColor().CGColor
        detailView.layer.borderWidth = 2.0
        detailView.loadHTMLString(gameData.info!, baseURL: nil)
    }
    
    @IBAction func goToGiantBomb(sender: AnyObject) {
        print("Go to website!")
    }
    
}
