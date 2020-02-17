//
//  AGBObject.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 17.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class AGBObject{
    
    private var title: String
    private var image : UIImage
    private var text : String
    
    init(title: String, image : UIImage, text : String){
        self.title = title
        self.image = image
        self.text = text
    }
    
    public var getTitle : String{
        return self.title
    }
    
    public var getImage : UIImage{
        return self.image
    }
    
    public var getText : String{
        return self.text
    }
    
}
