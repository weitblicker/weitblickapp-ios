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
        
        let url = NSURL(string: Constants.cycleURL)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url:url! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "key")!
        print(token)
        request.addValue("Token " + token, forHTTPHeaderField: "Authorization")
        let user = UserDefaults.standard
        let toursID = user.integer(forKey: "tours")
        let postString = ["start": start.dateAndTimetoStringISO() ,"end": end.dateAndTimetoStringISO(), "distance": distance.description, "project": projectID.description, "tour": toursID.description]
        let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
        request.httpBody = jsonUser
        print("Sending Segments ..")
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            print("Response")
           print(response)
            print("Data")
            print(data)
            if let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                print(jsondata)
            }
            
            print("Error")
            print(error)
        }
        task.resume()
        
        
        
        
    }
    
}
