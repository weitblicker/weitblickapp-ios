//
//  Project.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

class Project{
    private var id : Int
    private var name : String
    private var hosts : [String]
    private var description : String
    private var locationID : Int
    private var partnerID : [Int]
    
    init(id : Int,name : String,hosts : [String],description : String,locationID : Int,partnerID : [Int]){
        self.id = id
        self.name = name
        self.hosts = hosts
        self.description = description
        self.locationID = locationID
        self.partnerID = partnerID
    }
}
