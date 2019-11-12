//
//  NewsEntry.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

struct Image : Codable{
    let id : Int?
    let title : String?
    let caption : String?
    let imageURL : String?
    let date_taken : Date?
}

struct Gallery : Codable{
    let id : Int?
    let title : String?
    let description : String?
    let images : [Image]?
}

struct NewsDecodable : Codable{
    let id : String?
    let title : String?
    let text : String?
    let gallery : Gallery?
    let added : String?
    let updated : String?
    let range : String?
}

class NewsEntry{
    private var id : Int
    private var title : String
    private var text : String
    private var gallery : Gallery
    private var created : Date
    private var updated : Date
    private var range : String

    init(id : Int, title : String, text : String, gallery : Gallery, created : Date, updated : Date, range : String){
        
        self.id = id
        self.title = title
        self.text = text
        self.gallery = gallery
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
    
    public var getRange : String{
        return self.range
    }
    
    public func setText (text : String){
        self.text = text
        self.updated  = Date.init()
        // DB Synchronisation
    }
    
}
