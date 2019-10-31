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
    
    
}
