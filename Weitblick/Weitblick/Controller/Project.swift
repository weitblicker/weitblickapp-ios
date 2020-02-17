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
    private var image_origin : UIImage
    private var gallery : [UIImage]
    private var hosts : [Host]
    private var description : String
    private var location : Location
    private var partnerID : [Int]
    private var milestones : [Milestone]
    private var cycleObject : CycleEntry
    private var partners : [Partner]
    private var cellCount : Int
    private var donationGlobal : DonationGlobal
  
    
    private var news : [Int] = []
    private var blog : [Int] = []
    private var events : [Int] = []
    
    init(id : Int,published : Date, name : String, image: UIImage, gallery : [UIImage], hosts : [Host], description : String, location : Location, partnerID : [Int], cycleObject : CycleEntry, news : [Int], blog : [Int], milestones : [Milestone], partners : [Partner], cellCount : Int, donationGlobal : DonationGlobal , events : [Int]){
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
        self.milestones = milestones
        self.partners = partners
        self.cellCount = cellCount
        self.donationGlobal = donationGlobal
        self.events = events
        
        self.cycleObject = cycleObject
        
        let size = CGSize.init(width: 400 , height: 400)
        let size2 = CGSize.init(width: 1000, height: 400)
        self.image = self.image.crop(to: size)
        self.image_origin = image.crop(to: size2)
        
        self.gallery = gallery
       
    }
    
    public var getEvents : [Int]{
        return self.events
    }
    
    public var getDonationGlobal : DonationGlobal{
        return self.donationGlobal
    }
    
    public var getCelLCount : Int{
        return self.cellCount
    }
    public var getImageOrigin: UIImage{
        return self.image_origin
    }
    
    public var getPartners : [Partner]{
        return self.partners
    }
    
    public var getMilestones : [Milestone]{
        return self.milestones
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

    public var getHosts : [Host]{
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
    
    public var getCycleObject: CycleEntry{
        return self.cycleObject
    }

}
