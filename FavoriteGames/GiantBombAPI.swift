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
    
    func getGameData(gameName: String, completion: (description: String)-> Void){
        
        let urlString = "\(GiantBombAPI.Keys.BASE_URL)api_key=\(GiantBombAPI.Keys.API_KEY)&format=json&query=\(gameName)&resources=game"
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
         
            guard (error == nil) else {
                return
            }
            guard let data = data else {
                print("No Data was returned")
                return
            }
            
            let parsedResult: AnyObject!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }

            guard let results = parsedResult["results"]!![0] as? NSDictionary else {
                print("Cannot locate results")
                return
            }
            
            guard let returnedString = results["description"] else {
                completion(description: "Cannot find description")
                return
            }
            
            completion(description: returnedString as! String)
        }
        task.resume()
    }
}