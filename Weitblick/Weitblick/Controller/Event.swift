//
//  Event.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit



class Event{
    
    private var id : Int
    private var name : String
    private var description : String
    private var gallery : [UIImage]
    private var locationID : Int
    private var date : Date
    
    init(id : Int, name : String, description : String, locationID : Int,gallery : [UIImage], date : Date){
        
        self.id = id
        self.name = name
        self.description = description
        self.locationID = locationID
        self.gallery = gallery
        self.date = date
        
    }
    
    public var getID : Int{
        return self.id
    }
    
    public var getName : String{
        return self.name
    }
    
    public var getDescription : String{
        return self.description
    }
    
    public var getLocationID : Int{
        return self.locationID
    }
    
    public var getDate : Date{
        return self.date
    }
    
    public func setDescription(description : String){
        self.description = description
        //DB Synchronisation
    }
}
