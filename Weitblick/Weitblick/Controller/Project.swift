//
//  Project.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit


class Project{
    private var id : Int
    private var published : Date
    private var name : String
    private var image : UIImage
    private var gallery : [UIImage]
    private var hosts : [String]
    private var description : String
    private var location : Location
    private var partnerID : [Int]
    private var cycleID : [Int]
  
    private var news : [Int]
    private var blog : [Int]
    
    init(id : Int,published : Date, name : String, image: UIImage, gallery : [UIImage], hosts : [String], description : String, location : Location, partnerID : [Int], cycleID : [Int], news : [Int], blog : [Int]){
        self.id = id
        self.published = published
        self.name = name
        self.image = image
        self.hosts = hosts
        self.description = description
        self.location = location
        self.partnerID = partnerID
        self.news = news
        self.blog = blog

        self.cycleID = cycleID
        
        let size = CGSize.init(width: 668, height: 352)
        self.image = self.image.crop(to: size)
        
        self.gallery = gallery
       
    }
    
    public var getNews : [Int] {
        return self.news
    }
    
    public var getBlogs : [Int]{
        return self.blog
    }

    public var getID : Int {
        return self.id
    }

    public var getPublished : Date{
        return self.published
    }
    public var getName : String{
        return self.name
    }
    public var getGallery : [UIImage]{
        return self.gallery
    }
   
    public var getImage : UIImage{
        return self.image
    }

    public var getHosts : [String]{
        return self.hosts
    }

    public var getDescription : String {
        return self.description
    }
    
    public var getLocation : Location{
        return self.location
    }

    public var getPartnerID : [Int]{
        return self.partnerID
    }

    public var toString : String{
        return "ProjektID: " + self.id.description + "\n"
            + self.name + "\n"
    }
    
    public var getCycleIDCount: Int{
        return self.cycleID.count
    }

}
