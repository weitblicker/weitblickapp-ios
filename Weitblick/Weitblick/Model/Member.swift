//
//  Member.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 17.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class Member{
    
//    "name": "Sebastian Pütz",
//               "role": "Projektmanagement",
//               "image": "/media/spuetz.jpg",
//               "email": "spuetz@uos.de",
//               "text": "Text, bli bla blub"
    
    private var name : String
    private var role : String
    private var image : UIImage
    private var email : String
    private var text : String
    
    init(name: String, role : String, image : UIImage, email : String, text : String){
        self.name = name
        self.role = role
        self.image = image
        self.email = email
        self.text = text
    }
    
    public var getName : String{
        return self.name
    }
    
    public var getRole : String{
        return self.role
    }
    
    public var getImage : UIImage{
        return self.image
    }
    
    public var getEmail : String{
        return self.email
    }
    
    public var getText : String{
        return self.text
    }
}
