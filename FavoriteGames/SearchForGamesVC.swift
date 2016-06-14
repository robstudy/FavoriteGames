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

     private var retrievedArray: NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TABLE VIEW
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseId = "displayGameCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId) as! DisplayGameCell
        
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

        cell.gameNameText.text = gameName
        cell.gameImage.image = myImage
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrievedArray.count
    }
    
    @IBAction func searchForGames(sender: AnyObject) {
        let gameText = searchTextField.text
        GiantBombAPI.sharedSession.getGameData(gameText!, completion: { description in
            if description != [] {
                self.retrievedArray = description
                //print(self.retrievedArray)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            } else {
                print("No data retreived")
                return
            }
        })
    }
    
}
