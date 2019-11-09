//
//  NewsEntry.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

class NewsEntry{
    
    private var id : Int
    private var title : String
    private var text : String
    private var imageID : Int
    private var created : Date
    private var updated : Date
    private var range : String

    init(id : Int, title : String, text : String, imageID : Int, created : Date, updated : Date, range : String){
        
        self.id = id
        self.title = title
        self.text = text
        self.imageID = imageID
        self.created = created
        self.updated = updated
        self.range = range
        
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
    
    public var getRange : String{
        return self.range
    }
    
    public func setText (text : String){
        self.text = text
        self.updated  = Date.init()
        // DB Synchronisation
    }
    
}
