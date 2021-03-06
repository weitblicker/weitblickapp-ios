//
//  RouteService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 12.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

/*
 =============
 RouteService:
 =============
    - getRoutes: Fetching Data from all routes which are made by User.
 */

import UIKit

class RouteService{
    
    static func getRoutes(completion: @escaping(_ list : [RouteEntry]) ->()){
        var list : [RouteEntry] = []
        let url = NSURL(string: Constants.RoutesURL)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url:url! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Token: "+UserDefaults.standard.string(forKey: "key")!, forHTTPHeaderField: "Authorization")
        let user = UserDefaults.standard
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            if let data = data{
                let jsondata = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let routeArray = jsondata as? NSArray{
                    for route in routeArray{
                        if let routeDict = route as? NSDictionary{
                            guard let duration = routeDict.value(forKey: "duration")  else { return }
                            let durationString = duration as! String
                            let durationDouble = Double.init(durationString)
                            let durationInt = round(durationDouble!/60)
                            
                            guard let end = routeDict.value(forKey: "end")  else { return }
                            let endString = end as! String
                            let endDate = handleDate(date: endString)
                            
                            guard let euro = routeDict.value(forKey: "euro")  else { return }
                            let donationDouble = euro as! Double
                            
                            guard let km = routeDict.value(forKey: "km")  else { return }
                            let distanceDouble = km as! Double
                            
                            guard let tourJSON = routeDict.value(forKey: "tour") else { return }
                            let tour = tourJSON as! Int
                            let routeEntry = RouteEntry.init(tourID: tour, date: endDate, duration: Int(durationInt), distance: distanceDouble, donation: donationDouble)
                            list.append(routeEntry)
                        }
                    }
                }
                completion(list)
            }else{
                completion([])
            }
        }
        task.resume()
    }  
}
