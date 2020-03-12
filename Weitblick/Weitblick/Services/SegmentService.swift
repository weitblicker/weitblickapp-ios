//
//  SegmentService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 12.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

/*
 ===============
 SegmentService:
 ===============
    - getTourID: Asking REST API Server for unique Tour ID when User starts Tour
        -> tour id will be sent whenever user is sending a segment
    - sendSegment: Sending Segment data to REST API Server with Tour ID.
 */

import UIKit

class SegmentService{
    
    static func getTourID(completion: @escaping (_ id : Int) -> ()){
        let url = NSURL(string: "https://weitblicker.org/rest/cycle/tours/new")
        var request = URLRequest(url:url! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "key")!
        request.addValue("Token " + token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            if let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                if let tourDict = jsondata as? NSDictionary{
                    guard let tourID = tourDict.value(forKey: "tour_index") else { return }
                    let tourIDInt = tourID as! Int
                    completion(tourIDInt)
                }
            }
        }
        task.resume()
    }
    
    static func sendSegment(start: Date, end: Date, distance: Double, projectID: Int, tourID: Int, completion: @escaping (_ response: String) -> ()){
        
        let url = NSURL(string: Constants.cycleURL)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url:url! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "key")!
        request.addValue("Token " + token, forHTTPHeaderField: "Authorization")
        let user = UserDefaults.standard
        let toursID = user.integer(forKey: "tours")
        let postString = ["start": start.dateAndTimetoStringISO() ,"end": end.dateAndTimetoStringISO(), "distance": distance.description, "project": projectID.description, "tour": toursID.description]
        let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
        request.httpBody = jsonUser
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
        }
        task.resume()
    }
    
}
