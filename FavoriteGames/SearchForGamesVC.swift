//
//  SearchForGamesVC.swift
//  FavoriteGames
//
//  Created by Robert Garza on 6/13/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit

class SearchForGamesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    private var retrievedArray: NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureButton()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - TABLE VIEW
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("displayGameCell", forIndexPath: indexPath) as! DisplayGameCell
        cell.gameNameText.textColor = UIColor.whiteColor()
        
        let game = retrievedArray[indexPath.row]
        let gameName = game["name"] as! String
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
        let textAttributes = NSAttributedString(string: gameName, attributes:[
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 30)!,
            ])
        cell.gameNameText.attributedText = textAttributes
        cell.gameNameText.textAlignment = NSTextAlignment.Center
        cell.gameNameText.textAlignment = .Center
        cell.gameImage.image = myImage
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrievedArray.count
    }
    
    //MARK: - Search
    
    @IBAction func searchForGames(sender: AnyObject) {
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
    
    private func configureButton() {
        searchButton.layer.borderWidth = 2.0
        searchButton.layer.borderColor = UIColor.blackColor().CGColor
        searchButton.layer.cornerRadius = 8.0
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
    
}
