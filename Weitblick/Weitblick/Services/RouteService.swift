//
//  RouteService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 12.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RouteService{
    
    static func getRoutes(completion: @escaping(_ list : [RouteEntry]) ->()){
        var list : [RouteEntry] = []
        let url = NSURL(string: Constants.RoutesURL)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url:url! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        let user = UserDefaults.standard
        let token = user.string(forKey: "key")
        let postString = ["token": token] as! [String: String]
        do{
            let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
            request.httpBody = jsonUser
        }catch {
            print("Error: cannot create JSON from todo")
            return
        }
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            print(jsondata)
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
                        //let donationDouble = Double.init(donationString)
                        
                        guard let km = routeDict.value(forKey: "km")  else { return }
                        let distanceDouble = km as! Double
                        //let distanceDouble = Double.init(distanceString)
                        guard let tourJSON = routeDict.value(forKey: "tour") else { return }
                        let tour = tourJSON as! Int
                        let routeEntry = RouteEntry.init(tourID: tour, date: endDate, duration: Int(durationInt), distance: distanceDouble, donation: donationDouble)
                        list.append(routeEntry)
                    }
                }
            }
            completion(list)
        }
        task.resume()
        
    }
    
    
    
}
