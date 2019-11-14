//
//  NewsCollection.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 09.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

class NewsCollection{
    
    private var newsList : [NewsEntry]
    private var pointer : Int
    
    init(){
        self.newsList = []
        self.pointer = 0
    }
    
    public var getNewsList : [NewsEntry]{
        return self.newsList
    }
    
    public var getPointer : Int {
        return self.pointer
    }
    
    public func addNewsEntry(newsEntry : NewsEntry){
        self.newsList.append(newsEntry)
    }
    
}
