//
//  Milestone.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 02.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class Milestone{
    
    private var name : String
    private var description : String
    private var date : Date
    private var reached : Bool
    
    init(name : String, description : String, date : Date, reached : Bool){
        self.name = name
        self.description = description
        self.date = date
        self.reached = reached
    }
    
    init(){
        self.name = ""
        self.description = ""
        self.date = Date()
        self.reached = false
    }
    
    public var getName : String{
        return self.name
    }
    
    public var getDescription : String{
        return self.description
    }
    
    public var getDate : Date{
        return self.date
    }
    
    public var isReached : Bool{
        return self.reached
    }
}
