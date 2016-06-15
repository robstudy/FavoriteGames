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
    
    //MARK: - IBActions
    
    @IBAction func goToGiantBomb(sender: AnyObject) {
        if let url = NSURL(string: gameData.siteUrl!) {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            } else {
                displayAlertView()
            }
        }
    }
    
    @IBAction func deleteGame(sender: AnyObject) {
        //performFetch()
        sharedContext.deleteObject(gameData)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - Alert View
    
    private func displayAlertView() {
        let okPress = UIAlertAction(title: "OK", style: .Default) { action in
            return
        }
        dispatch_async(dispatch_get_main_queue(), {
            let warningAlert = UIAlertController(title: "WARNING!", message: "Can't open link to GiantBomb", preferredStyle: .Alert)
            warningAlert.addAction(okPress)
            self.presentViewController(warningAlert, animated: true, completion: nil)
        })
    }
    
    //MARK: - Core Data Functions
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
}
