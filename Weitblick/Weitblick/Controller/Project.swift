//
//  Project.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

struct ProjectDecodable : Codable{
    let id : String?
    let published : String?
    let name : String?
    let gallery : [String]?
    let hosts : [String]?
    let description : String?
    let location : Int?
    let partner : [Int]?
    let cycle : [Int]?
}

class Project{
    private var id : Int
    private var published : Date
    private var name : String
    private var gallery : Gallery
    private var galleryCount : Int
    private var hosts : [String]
    private var description : String
    private var location : Location
    private var partnerID : [Int]
    private var cycleID : [Int]
  


    init(id : Int,published : Date, name : String, gallery : Gallery, hosts : [String], description : String, location : Location, partnerID : [Int], cycleID : [Int]){
        self.id = id
        self.published = published
        self.name = name
        self.gallery = gallery
        self.galleryCount = self.gallery.images!.count
        self.hosts = hosts
        self.description = description
        self.location = location
        self.partnerID = partnerID
        self.cycleID = cycleID
       
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

    public var getGalleryCount : Int{
        return self.galleryCount
    }

    public func getImageURL(index : Int) -> String{
       return self.gallery.images![index].imageURL!
    }

    public var getGallery : Gallery{
        return self.gallery
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
    
    public var getCycleID : [Int]{
        return self.cycleID
    }
    
    public var getCycleIDCount : Int{
        
        print("anzahl cycle" + self.cycleID.count.description)
        return self.cycleID.count
       }

    public var toString : String{
        return "ProjektID: " + self.id.description + "\n"
            + self.name + "\n"
    }

}
