//
//  BlogEntry.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class BlogEntry{
    
    private var id : Int
    private var title : String
    private var text : String
    private var image : UIImage
    private var created : Date
    private var updated : Date
    private var teaser : String
    private var range : String
    private var gallery : [UIImage]
    private var projectInt : Int
    private var author : Author

    init(id : Int, title : String, text : String,  created : Date, updated : Date, image : UIImage, teaser : String, range: String, gallery : [UIImage], projectInt : Int, author : Author){
        
        self.id = id
        self.title = title
        self.text = text
        self.created = created
        self.updated = updated
        self.image = image
        self.teaser = teaser
        self.range = range
        self.projectInt = projectInt
        let size = CGSize.init(width: 414, height: 235)
        self.image = self.image.crop(to: size)
        self.gallery = gallery
        self.author = author
        
    }
    
    public var getAuthor : Author{
        return self.author
    }
        
    
    public var getprojectInt : Int{
        return self.projectInt
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
    
    public var getImage : UIImage{
        return self.image
    }
    

    
    public var getCreationDate : Date{
        return self.created
    }
    
    public var getUpdateDate : Date{
        return self.updated
    }
    
    public var getTeaser : String{
        return self.teaser
    }
    
    public var getRange : String{
        return self.range
    }
    
    public var getGallery : [UIImage]{
        return self.gallery
    }
    
    public func setText (text : String){
        self.text = text
        self.updated  = Date.init()
        // DB Synchronisation
    }

}
