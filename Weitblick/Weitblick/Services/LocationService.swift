//
//  LocationService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 07.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class LocationService{
    
//    static func getLocation(locationID: String,completion: @escaping (_ location: Location) -> ()){
//        print("In Location GetLocation")
//        let urlString = Constants.restURL + "/locations/" + locationID
//        let url = NSURL(string: urlString)
//        let str = "surfer:hangloose"
//        let test2 = Data(str.utf8).base64EncodedString();
//        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
//        task.httpMethod = "GET"
//        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        task.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
//        URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
//            let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//            if let projectDict = jsondata as? NSDictionary{
//                guard let id = projectDict.value(forKey: "id")  else { return }
//                let locationID = id as! Int
//                guard let lat = projectDict.value(forKey: "lat")  else { return }
//                let locationLat = lat as! Float
//                guard let lng = projectDict.value(forKey: "lng")  else { return }
//                let locationLng = lng as! Float
//                guard let address = projectDict.value(forKey: "address")  else { return }
//                let locationAddress = address as! String
//                let location = Location(id: locationID, lat: locationLat, lng: locationLng, address: locationAddress)
//                print(location.getAddress)
//                completion(location)
//            }
//        })
//    }
}
