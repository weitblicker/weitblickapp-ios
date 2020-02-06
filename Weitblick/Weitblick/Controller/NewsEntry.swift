//
//  NewsEntry.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class NewsEntry{
    private var id : Int
    private var title : String
    private var text : String
    private var image : UIImage
    private var gallery : [UIImage] = []
    private var created : Date
    private var updated : Date
    private var range : String
    private var teaser : String
    private var host : Host
    private var projectInt : Int

    init(id : Int, title : String, text : String, gallery : [UIImage], created : Date, updated : Date, range : String, image : UIImage, teaser: String, host : Host, projectInt : Int){

        self.id = id
        self.title = title
        self.text = text
        self.host = host
        self.created = created
        self.updated = updated
        self.range = range
        self.image = image
        self.teaser = teaser
        self.projectInt = projectInt
        
        let size = CGSize.init(width: 668, height: 284)
        self.image = self.image.crop(to: size)
        
        
        
        let screenRect = UIScreen.main
        let screenWidth = screenRect.bounds.width
        let photosize = CGSize.init(width: screenWidth, height: 220)
        var image : UIImage?
        for img in gallery{
            image = img.crop(to: photosize)
            self.gallery.append(image!)
        }
    }
    public var getProjectInt : Int{
        return self.projectInt
    }
    
    public var getHost : Host{
        return self.host
    }
    
    public var getImage : UIImage{
        return self.image
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

    
    public var getGallery : [UIImage]{
           return self.gallery
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
    
    public var getTeaser : String{
        return self.teaser
    }

    public func setText (text : String){
        self.text = text
        self.updated  = Date.init()
        // DB Synchronisation
    }

}
