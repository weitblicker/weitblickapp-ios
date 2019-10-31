//
//  Location.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation


class Location{
    
    private var id : Int
    private var name : String
    private var description : String
    private var lat : Float
    private var lng : Float
    private var address : String
    
    init(id : Int, name : String, description : String, lat : Float, lng : Float, address : String ){
        
        self.id = id
        self.name = name
        self.description = description
        self.lat = lat
        self.lng = lng
        self.address = address
        
    }
    
}
