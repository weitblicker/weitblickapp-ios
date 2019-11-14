//
//  EventCollection.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 09.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

class EventCollection{
    
    private var eventList : [Event]
    private var pointer : Int
    
    init(){
        self.eventList = []
        self.pointer = 0
    }
    
    public var getEventList : [Event]{
        return self.eventList
    }
    
    public var getPointer : Int {
        return self.pointer
    }
    
    public func addEvent(event : Event){
        self.eventList.append(event)
    }
    
}
