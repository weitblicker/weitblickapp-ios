//
//  User.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 12.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class User{
    
    private var username : String
    private var image : UIImage
    private var km : Double
    private var euro : Double
    
    init(username : String, image : String, km : Double, euro : Double){
        self.username = username
        print(image)
        if(image == ""){
            self.image = UIImage(named: "profileBlack100")!
        }else{
            let imgURL = NSURL(string :  image)
            let data = NSData(contentsOf: (imgURL as URL?)!)
            self.image = UIImage(data: data! as Data)!
            
        }
        
        let size = CGSize.init(width: 100, height: 100)
        self.image = self.image.crop(to: size)
        
        self.km = km
        self.euro = euro
    }
    
    public var getUsername : String{
        return self.username
    }
    
    public var getImage : UIImage{
        return self.image
    }
    
    public var getKm : Double{
        return self.km
    }
    
    public var getEuro : Double{
        return self.euro
    }
    
}
