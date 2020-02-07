//
//  Donation.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 06.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class Donation{
    
    private var id : Int
    private var sponsor : Sponsor
    private var name : String
    private var description : String
    private var goal_amount : Float
    private var rate_euro_km : Float
    
    init(id : Int, sponsor : Sponsor, name : String, description : String, goal_amount : Float, rate_euro_km : Float){
        self.id = id
        self.sponsor = sponsor
        self.name = name
        self.description = description
        self.goal_amount = goal_amount
        self.rate_euro_km = rate_euro_km
    }
    
    init(){
        self.id = 0
        self.sponsor = Sponsor()
        self.name = ""
        self.description = ""
        self.goal_amount = 0
        self.rate_euro_km = 0
        
    }
    
    public var getID : Int{
        return self.id
    }
    
    public var getSponsor : Sponsor{
        return self.sponsor
    }
    
    public var getName : String{
        return self.name
    }
    
    public var getDescription : String{
        return self.description
    }
    
    public var getGoalAmount : Float{
        return self.goal_amount
    }
    
    public var getRateEuroKM : Float{
        return self.rate_euro_km
    }
}
