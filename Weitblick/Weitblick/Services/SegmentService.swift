//
//  SegmentService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 12.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class SegmentService{
    
    static func sendSegment(start: Date, end: Date, distance: Double, projectID: Int, tourID: Int, completion: @escaping (_ response: String) -> ()){
        /*
         {
             "start": "2019-10-01T07:08:04Z",
             "end": "2019-10-01T07:08:14Z",
             "distance": 0.1,
             "project": 1,
             "tour": 0,
             "token":"foo"
         }
         */
        
        let url = NSURL(string: Constants.cycleURL)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url:url! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        let user = UserDefaults.standard
        let toursID = user.integer(forKey: "tours")
        let token = user.string(forKey: "key")
        let postString = ["start": start.dateAndTimetoStringISO() ,"end": end.dateAndTimetoStringISO(), "distance": distance.description, "project": projectID.description, "tour": toursID.description, "token": token] as! [String: String]
        do{
            let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
            request.httpBody = jsonUser
        }catch {
            print("Error: cannot create JSON from todo")
            return
        }
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            print(response?.description)
        }
        task.resume()
        
        
        
        
    }
    
}
