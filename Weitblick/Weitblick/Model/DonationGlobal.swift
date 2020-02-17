//
//  DonationGlobal.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 17.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class DonationGlobal{
    
    private var donation_goal : Float
    private var donation_description : String
    private var donation_current : Float
    private var donation_account : BankAccount
    
    init(goal : Float, description : String, current : Float, account : BankAccount){
        self.donation_goal = goal
        self.donation_description = description
        self.donation_current = current
        self.donation_account = account
    }
    
    public var getDonationGoal : Float{
        return self.donation_goal
    }
    
    public var getDescription : String{
        return self.donation_description
    }
    
    public var getCurrent : Float{
        return self.donation_current
    }
    
    public var getDonationAccount : BankAccount{
        return self.donation_account
    }
}
