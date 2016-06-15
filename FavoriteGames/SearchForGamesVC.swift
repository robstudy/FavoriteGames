//
//  SearchForGamesVC.swift
//  FavoriteGames
//
//  Created by Robert Garza on 6/13/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit
import CoreData

class SearchForGamesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    private var retrievedArray: NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - TableView Data Source and Delegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("displayGameCell", forIndexPath: indexPath) as! DisplayGameCell
        cell.gameNameText.textColor = UIColor.whiteColor()
        
        let game = retrievedArray[indexPath.row]
        let gameName = game["name"] as! String
        let textAttributes = NSAttributedString(string: gameName, attributes:[
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 30)!,
            ])
        
        guard let imageDictionary = game["image"] as? NSDictionary else {
            cell.gameNameText.text = gameName
            return cell
        }
        
        let thumbnailLink = imageDictionary["thumb_url"] as! String
        
        var imageurl: String
        if thumbnailLink.containsString("http") {
            imageurl = thumbnailLink
        } else {
            imageurl = "http://static.giantbomb.com/\(thumbnailLink)"
        }
        
        guard let imageData = NSData(contentsOfURL: NSURL(string: imageurl)!) else {
            cell.gameNameText.text = gameName
            return cell
        }
        
        guard let myImage =  UIImage(data: imageData) else {
            cell.gameNameText.text = gameName
            return cell
        }
        
        cell.gameNameText.textColor = UIColor.whiteColor()
        cell.gameNameText.attributedText = textAttributes
        cell.gameNameText.textAlignment = NSTextAlignment.Center
        cell.gameNameText.textAlignment = .Center
        cell.gameImage.image = myImage
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrievedArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DisplayGameCell
        let gameData = retrievedArray[indexPath.row]
        let gameName = gameData["name"]
        let cellImage: NSData
        if cell.gameImage.image != nil {
            cellImage = UIImagePNGRepresentation(cell.gameImage.image!)!
        } else {
            print("No Image Data returning")
            return
        }
        let deck = gameData["deck"]
        let info = gameData["description"]
        let siteURL = gameData["site_detail_url"]
        let id = gameData["id"]
        
        let testArray = [gameName, cellImage, deck, info, siteURL, id]
        for item in testArray {
            if item is NSNull {
                displayAlertView()
                return
            }
        }
        
        let savedGame = Game(gameName: gameName as! String, thumbNail: cellImage, gameDeck: deck as! String, gameInfo: info as! String, siteURL: siteURL as! String, id: id as! Int, context: sharedContext)
        
        print("Saved game \(savedGame.name)")
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - Search
    
    @IBAction func searchForGames(sender: AnyObject) {
        retrievedArray = []
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
        let gameText = searchTextField.text
        toggleActivityView(true)
        GiantBombAPI.sharedSession.getGameData(gameText!, completion: { description in
            if description != [] {
                self.retrievedArray = description
                //print(self.retrievedArray)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.toggleActivityView(false)
                })
            } else {
                print("No data retreived")
                self.toggleActivityView(false)
                return
            }
        })
    }
    
    //MARK: - Private UI Functions
    
    private func configureViewController() {
        tableView.delegate = self
        tableView.dataSource = self
        searchButton.layer.borderWidth = 2.0
        searchButton.layer.cornerRadius = 8.0
        searchButton.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    private func toggleActivityView(on: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            if on {
                self.activityView.startAnimating()
                self.view.bringSubviewToFront(self.activityView)
                self.searchTextField.enabled = false
                self.searchButton.enabled = false
                self.tableView.alpha = 0.3
                self.searchButton.alpha = 0.3
                self.searchTextField.alpha = 0.3
            } else {
                self.activityView.stopAnimating()
                self.searchTextField.enabled = true
                self.searchButton.enabled = true
                self.tableView.alpha = 1.0
                self.searchButton.alpha = 1.0
                self.searchTextField.alpha = 1.0
            }
        })
    }
    
    private func displayAlertView() {
        let okPress = UIAlertAction(title: "OK", style: .Default) { action in
            return
        }
        dispatch_async(dispatch_get_main_queue(), {
            let warningAlert = UIAlertController(title: "WARNING!", message: "Problem retrieving data from source. Undable to use cell.", preferredStyle: .Alert)
            warningAlert.addAction(okPress)
            self.presentViewController(warningAlert, animated: true, completion: nil)
        })
    }
    
    //MARK: - Core Data Shared Context
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
}
