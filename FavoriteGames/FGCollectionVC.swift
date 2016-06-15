//
//  FGCollectionVC.swift
//  FavoriteGames
//
//  Created by Robert Garza on 6/11/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "collectionCell"

class FGCollectionVC: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    private var gameToSend: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
        configureViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        performFetch()
        saveData()
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()
            self.collectionView?.layoutIfNeeded()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UICollectionView Data Source and Delegate

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GameCollectionCell
        
        let cellData = fetchedResultsController.objectAtIndexPath(indexPath) as! Game
        
        let cellImage = UIImage(data: cellData.thumbnail!)
        
        cell.backgroundView = UIImageView(image: cellImage)
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = fetchedResultsController.objectAtIndexPath(indexPath) as! Game
        gameToSend = cell
        self.performSegueWithIdentifier("gameDetail", sender: collectionView)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "gameDetail") {
            let gameDetail = segue.destinationViewController as! GameDetailVC
            gameDetail.gameData = gameToSend
        }
    }

    //MARK: - Private UI Functions
    
    private func configureViewController() {
        fetchedResultsController.delegate = self
        
        self.collectionView!.registerClass(GameCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let dimension = (self.view.frame.width / 3.0)
        
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
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
