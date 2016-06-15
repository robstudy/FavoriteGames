//
//  GiantBombAPI.swift
//  FavoriteGames
//
//  Created by Robert Garza on 6/10/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import Foundation

class GiantBombAPI: NSObject {
    
    static let sharedSession = GiantBombAPI()
    private let session = NSURLSession.sharedSession()
    
    func getGameData(gameName: String, completion: (gameData: NSArray)-> Void){
        
        var composedWord: String = ""
        
        for character in gameName.characters {
            if character == " " {
                composedWord += "+"
            } else {
                composedWord += String(character)
            }
        }
        
        let urlString = "\(GiantBombAPI.Keys.BASE_URL)api_key=\(GiantBombAPI.Keys.API_KEY)&format=json&query=\(composedWord)&limit=15&resources=game"
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
         
            if error != nil {
                print("Error")
                completion(gameData: [])
                return
            }

            guard let data = data else {
                print("No Data was returned")
                return
            }
            
            var results: [String: AnyObject]!
            
            do {
                let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let theResults = parsedResult as? [String: AnyObject] {
                    results = theResults
                }
        
            } catch {
                results = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            let resultsArray = results["results"] as! NSArray
            
            completion(gameData: resultsArray)
        }
        task.resume()
    }
}