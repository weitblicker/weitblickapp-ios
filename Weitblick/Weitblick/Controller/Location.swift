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
    private var lat : Double
    private var lng : Double
    private var address : String
    
    init(id : Int, lat : Double, lng : Double, address : String ){
        
        self.id = id
        self.lat = lat
        self.lng = lng
        self.address = address
        
    }
    
    init(){
        self.id = 0
        self.lat = 0
        self.lng = 0
        self.address = ""
    }
    
    public var getID : Int{
        return self.id
    }
    
    public var getLatitude : Double{
        return self.lat
    }
    
    public var getLongitude : Double{
        return self.lng
    }
    
    public var getAddress : String{
        return self.address
    }
}
