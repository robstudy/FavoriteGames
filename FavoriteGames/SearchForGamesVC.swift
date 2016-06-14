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
            NSStrokeColorAttributeName:UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSStrokeWidthAttributeName: -3.0
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
    
    private func configureButton() {
        searchButton.layer.borderWidth = 2.0
        searchButton.layer.borderColor = UIColor.blackColor().CGColor
        searchButton.layer.cornerRadius = 8.0
    }
    
}
