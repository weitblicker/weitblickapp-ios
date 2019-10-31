//
//  Event.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

class Event{
    
    private var id : Int
    private var name : String
    private var locationID : Int
    private var date : Date
    
    init(id : Int, name : String, locationID : Int, date : Date){
        
        self.id = id
        self.name = name
        self.locationID = locationID
        self.date = date
        
    }
}
