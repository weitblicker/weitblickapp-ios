//
//  BlogEntry.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

struct BlogDecodable : Codable{
    let id : String?
    let title : String?
    let text : String?
    let gallery : Gallery?
    let added : String?
    let updated : String?
    let range : String?
}

class BlogEntry{
    
    private var id : Int
    private var title : String
    private var text : String
    private var gallery : Gallery
    private var created : Date
    private var updated : Date
    private var locationID : Int

    init(id : Int, title : String, text : String, gallery : Gallery, created : Date, updated : Date, locationID : Int){
        
        self.id = id
        self.title = title
        self.text = text
        self.gallery = gallery
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
    
    public func getImageURL(index : Int) -> String{
        if(index >= 0 && index < self.gallery.images!.count){
            return self.gallery.images![index].imageURL!
        }else{
            return "NO_IMAGES_IN_GALLERY_ERROR"
        }
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
