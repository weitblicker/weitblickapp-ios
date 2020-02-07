//
//  Sponsor.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 06.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class Sponsor{
    
    private var name : String
    private var description : String
    private var logo : UIImage
    private var link : String
    
    init(name : String, description : String, logo : UIImage, link : String){
        
        self.name = name
        self.description = description
        self.logo = logo
        self.link = link
        
    }
    
    init(){
        self.name = ""
        self.description = ""
        self.logo = UIImage.init(named: "Weitblick")!
        self.link = ""
    }
    
    public var getName : String{
        return self.name
    }
    
    public var getDescription : String{
        return self.description
    }
    
    public var getLogo : UIImage{
        return self.logo
    }
    
    public var getLink : String{
        return self.link
    }
}
