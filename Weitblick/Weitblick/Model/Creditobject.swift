//
//  Creditobject.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 17.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class Creditobject{
    
    private var id : Int
    private var name : String
    private var description : String
    private var image : UIImage
    private var members : [Member]
    
    init(id : Int, name : String, description : String, image : UIImage, members : [Member]){
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.members = members
    }
    
    public var getID : Int{
        return self.id
    }
    
    public var getName : String{
        return self.name
    }
    
    public var getDescription : String{
        return self.description
    }
    
    public var getImage : UIImage{
        return self.image
    }
    
    public var getMembers : [Member]{
        return self.members
    }
    
}
