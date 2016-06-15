//
//  Game.swift
//  FavoriteGames
//
//  Created by Robert Garza on 6/14/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import Foundation
import CoreData


class Game: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    
    
    init(gameName: String, thumbNail: NSData, gameDeck: String, gameInfo: String, siteURL: String, id: Int, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Game", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        name = gameName
        thumbnail = thumbNail
        deck = gameDeck
        info = gameInfo
        siteUrl = siteURL
        gameId = id
    }
}
