//
//  Event.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

struct EventDecodable : Codable{
    let id : String?
    let title : String?
    let text : String?
    let gallery : Gallery
    let added : String?
    let updated : String?
    let range : String?
}

class Event{
    
    private var id : Int
    private var name : String
    private var description : String
    private var gallery : Gallery
    private var locationID : Int
    private var date : Date
    
    init(id : Int, name : String, description : String, locationID : Int,gallery : Gallery, date : Date){
        
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
    
    public func getImageURL(index : Int) -> String{
        if(index >= 0 && index < self.gallery.images!.count){
            return self.gallery.images![index].imageURL!
        }else{
            return "NO_IMAGES_IN_GALLERY_ERROR"
        }
    }
    
    public var getDate : Date{
        return self.date
    }
    
    public func setDescription(description : String){
        self.description = description
        //DB Synchronisation
    }
}
