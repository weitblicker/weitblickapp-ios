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

    init(id : Int, title : String, text : String,  created : Date, updated : Date, image : UIImage, teaser : String, range: String){
        
        self.id = id
        self.title = title
        self.text = text
        self.created = created
        self.updated = updated
        self.image = image
        self.teaser = teaser
        self.range = range
        
        let size = CGSize.init(width: 334, height: 176)
        self.image = self.image.crop(to: size)
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
    
    public func setText (text : String){
        self.text = text
        self.updated  = Date.init()
        // DB Synchronisation
    }

}
