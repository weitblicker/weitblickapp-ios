//
//  CycleEntry.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 06.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class CycleEntry{
    
    private var eurosum : Float
    private var euro_goal : Float
    private var donations : [Donation]
    private var progress : Float
    private var km_sum : Float
    private var cyclists : Int
    
    init(eurosum : Float, euro_goal : Float, donations : [Donation], progress : Float, km_sum : Float, cyclists : Int){
        self.eurosum = eurosum
        self.euro_goal = euro_goal
        self.donations = donations
        self.progress = progress
        self.km_sum = km_sum
        self.cyclists = cyclists
        
    }
    
    public var getEuroSum : Float{
        return self.eurosum
    }
    
    public var getEuroGoal : Float{
        return self.euro_goal
    }
    
    public var getDonations : [Donation]{
        return self.donations
    }
    
    public var getProgress : Float{
        return self.progress
    }
    
    public var getkmSum : Float{
        return self.km_sum
    }
    
    public var getCyclists : Int{
        return self.cyclists
    }
}
