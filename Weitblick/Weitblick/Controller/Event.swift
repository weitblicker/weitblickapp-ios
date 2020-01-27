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
    private var title : String
    private var description : String
    private var image : UIImage
    private var host : String
    private var gallery : [UIImage]
    private var location : Location
    private var dateStart : Date
    private var dateEnd : Date
    
    init(id : Int, title : String, description : String,image : UIImage, host : String, location : Location,gallery : [UIImage], dateStart : Date, dateEnd : Date){
        
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.host = host
        self.location = location
        self.gallery = gallery
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        
    }
    
    public var getID : Int{
        return self.id
    }
    
    public var getTitle : String{
        return self.title
    }
    
    public var getDescription : String{
        return self.description
    }
    
    public var getLocation : Location{
        return self.location
    }
    
    public var getStartDate : Date{
        return self.dateStart
    }
    
    public var getHost : String{
        return self.host
    }
    
    public var getImage : UIImage{
        return self.image
    }
}
