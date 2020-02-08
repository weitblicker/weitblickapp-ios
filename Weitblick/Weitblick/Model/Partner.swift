//
//  Partner.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 08.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class Partner{
    
    private var name : String
    private var description : String
    private var logo : UIImage
    
    init(name : String, description : String, logo : UIImage){
        self.name = name
        self.description = description
        self.logo = logo
    }
    
    init(){
        self.name = ""
        self.description = ""
        self.logo = UIImage(named : "Weitblick")!
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
    
}
