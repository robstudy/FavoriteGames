//
//  FGTabVC.swift
//  FavoriteGames
//
//  Created by Robert Garza on 6/11/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit
import CoreData

class FGTabVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private var gameToSend: Game!

    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        performFetch()
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
        saveData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - TableView Data Source and Delegate

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("showGameCell", forIndexPath: indexPath) as! DisplayGameCell
        let cellData = fetchedResultsController.objectAtIndexPath(indexPath) as! Game
        
        let textAttributes = NSAttributedString(string: cellData.name!, attributes:[
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 30)!,
            ])
        
        cell.gameImage.image = UIImage(data: cellData.thumbnail!)
        cell.gameNameText.attributedText = textAttributes
        cell.gameNameText.textAlignment = NSTextAlignment.Center
        cell.gameNameText.textAlignment = .Center

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let gameData = fetchedResultsController.objectAtIndexPath(indexPath) as! Game
            sharedContext.deleteObject(gameData)
            performFetch()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } 
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = fetchedResultsController.objectAtIndexPath(indexPath) as! Game
        gameToSend = cell
        self.performSegueWithIdentifier("gameDetail", sender: tableView)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "gameDetail") {
            let gameDetail = segue.destinationViewController as! GameDetailVC
            gameDetail.gameData = gameToSend
        }
    }

    //MARK: - Core Data Functions
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Game")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
    }()
    
    private func saveData() {
        do {
            try self.sharedContext.save()
        } catch {
            print("Could not save!")
        }
    }
    
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
}
