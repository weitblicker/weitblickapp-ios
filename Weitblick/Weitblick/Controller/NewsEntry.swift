//
//  NewsEntry.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

struct Image : Codable{
    let imageURL : String?
}

struct Gallery : Codable{
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
    private var image : Image
    private var uiimage : UIImage = UIImage(named: "Weitblick")!
    private var gallery : Gallery
    private var created : Date
    private var updated : Date
    private var range : String
    private var teaser : String

    init(id : Int, title : String, text : String, gallery : Gallery, created : Date, updated : Date, range : String, image : Image, teaser: String){

        self.id = id
        self.title = title
        self.text = text
        self.gallery = gallery
        self.created = created
        self.updated = updated
        self.range = range
        self.image = image
        self.teaser = teaser
        
        if(self.image.imageURL == ""){
            if(self.gallery.images!.count >= 1){
                let imgURL = NSURL(string : Constants.url + (self.gallery.images?.first?.imageURL)! )
                if(imgURL != nil){
                    let data = NSData(contentsOf: (imgURL as URL?)!)
                    let size = CGSize.init(width: 334, height: 176)
                    let img = UIImage(data: data! as Data)?.crop(to: size)
                    self.uiimage = img!
                }
            }else{
                self.uiimage = UIImage(named: "Weitblick")!
            }
        }else{
            let imgURL = NSURL(string : Constants.url + self.image.imageURL!)
            if(imgURL != nil){
                let data = NSData(contentsOf: (imgURL as URL?)!)
                self.uiimage = UIImage(data: data! as Data)!
            }else{
                self.uiimage = UIImage(named: "Weitblick")!
            }
            
        }
    }
    
    public var getImage : UIImage{
        return self.uiimage
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

    public func getImageURLFromGallery(index : Int) -> String{
        if(index >= 0 && index < self.gallery.images!.count){
            return self.gallery.images![index].imageURL!
        }else{
            return "NO_IMAGES_IN_GALLERY_ERROR"
        }
    }
    
    public var getGallery : Gallery{
           return self.gallery
       }

    public var getImageURL : String{
        return self.image.imageURL!
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
