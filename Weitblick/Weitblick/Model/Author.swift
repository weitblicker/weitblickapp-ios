//
//  Author.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 07.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class Author{
    
    private var image : UIImage
    private var name : String
    
    init(image : UIImage, name : String){
        self.image = image
        self.name = name
    }

    init(){
        self.image = UIImage(named: "Weitblick")!
        self.name = ""
    }
    
    public var getImage : UIImage{
        return self.image
    }
    
    public var getName : String{
        return self.name
    }

}