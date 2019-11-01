//
//  BlogEntry.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

class BlogEntry{
    
    private var id : Int
    private var title : String
    private var text : String
    private var imageID : Int
    private var created : Date
    private var updated : Date
    private var locationID : Int

    init(id : Int, title : String, text : String, imageID : Int, created : Date, updated : Date, locationID : Int){
        
        self.id = id
        self.title = title
        self.text = text
        self.imageID = imageID
        self.created = created
        self.updated = updated
        self.locationID = locationID
        
    }
    
    public var getID : Int{
        return self.id
    }
    
    public var getTitle : String {
        return self.title
    }
    
    public var getText : String{
        return self.text
    }
    
    public var getImageID : Int{
        return self.imageID
    }
    
    public var getCreationDate : Date{
        return self.created
    }
    
    public var getUpdateDate : Date{
        return self.updated
    }
    
    public var getLocationID : Int{
        return self.locationID
    }
    
    public func setText (text : String){
        self.text = text
        self.updated  = Date.init()
        // DB Synchronisation
    }
    
}
