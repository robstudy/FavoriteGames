//
//  Game+CoreDataProperties.swift
//  FavoriteGames
//
//  Created by Robert Garza on 6/14/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Game {

    @NSManaged var name: String?
    @NSManaged var thumbnail: NSData?
    @NSManaged var deck: String?
    @NSManaged var info: String?
    @NSManaged var siteUrl: String?

}
