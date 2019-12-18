//
//  RouteEntry.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 12.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RouteEntry{
    
    private var tourID : Int
    private var date : Date
    private var duration : Int
    private var distance : Double
    private var donation : Double
    
    init(tourID: Int, date: Date, duration : Int, distance: Double, donation: Double) {
        self.tourID = tourID
        self.date = date
        self.duration = duration
        self.distance = distance
        self.donation = donation
    }
    
    public var getTourID: Int{
        return self.tourID
    }
    
    public var getDate: Date{
        return self.date
    }
    
    public var getDuration: Int{
        return self.duration
    }
    
    public var getDistance: Double{
        return self.distance
    }
    
    public var getDonation: Double{
        return self.donation
    }
    
}
