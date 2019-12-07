//
//  BlogCollection.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 09.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

class BlogCollection{
    
    private var blogList : [BlogEntry]
    private var pointer : Int
    
    init(){
        self.blogList = []
        self.pointer = 0
    }
    
    public var getBlogList : [BlogEntry]{
        return self.blogList
    }
    
    public var getPointer : Int {
        return self.pointer
    }
    
    public func addBlogEntry(blogEntry : BlogEntry){
        self.blogList.append(blogEntry)
    }
    
}
