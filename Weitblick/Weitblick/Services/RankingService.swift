//
//  RankingService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 12.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RankingService{
   
    static func getRankings(completion: @escaping (_ list : [User]) -> ()){
        var userList : [User] = []
        
        let url = NSURL(string: Constants.RankingURL)
        //print(Constants.restURL + "/news?end="+date.dateAndTimetoStringUS()+"&limit=3")
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        
        /*
         "username": "janaJoy",
         "image": null,
         "km": 0.0,
         "euro": 0.0
         */
        URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
            if let data = data{
                let jsondata = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)

                            
                                 if let userDict = jsondata as? NSDictionary{

                             
                                     
                                     if let userArray = userDict.value(forKey: "best_field") as? NSArray{
                
                                         for user in userArray{

                                             if let userDict = user as? NSDictionary{
                                                 let userString = userDict.value(forKey: "username") as? String ?? ""

                                                 var userImage : String = ""
                                                 userImage = userDict.value(forKey: "image") as? String ?? ""
                  
                                                 guard let km = userDict.value(forKey: "km")  else { return }
                                                 let userKM = km as! Double
                                                 guard let euro = userDict.value(forKey: "euro")  else { return }
                                                 let userEuro = euro as! Double
                                                 let userEntry = User(username: userString, image: userImage, km: userKM, euro: userEuro)
                                                  userList.append(userEntry)
                                              
                                             }
                                     
                                         }
                                           
                                     }
                             
                         }
                         completion(userList)
            }else{
                completion([])
            }
        }).resume()
    }
}
