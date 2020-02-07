//
//  CycleService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 06.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class CycleService{
    
    static func fireSegments(start: Date, end: Date, distance : Double, projectID : Int, tourID: Int, token: String){
        
//        {
//            "start": "2019-10-01T07:08:04Z",
//            "end": "2019-10-01T07:08:14Z",
//            "distance": 0.1,
//            "project": 1,
//            "tour": 0,
//            "token":"foo"
//        }
        let s = Constants.restURL + "/cycle/segment/"
        let url = NSURL(string: s)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        //print(test2)
        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        
        let poststring = ["start": start.description,
                          "end": end.description,
                          "distance": distance.description,
                          "project": projectID.description,
                          "tour": tourID.description,
                          "token": token
        ] as [String: String]
        let jsonSegment = try? JSONSerialization.data(withJSONObject: poststring, options:[])
        task.httpBody = jsonSegment

    }
}
