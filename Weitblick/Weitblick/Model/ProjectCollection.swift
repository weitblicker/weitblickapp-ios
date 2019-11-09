//
//  ProjectCollection.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 09.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation

class ProjectCollection{
    
    private var projectList : [Project]
    private var pointer : Int
    
    init(){
        self.projectList = []
        self.pointer = 0
    }
    
    public var getProjectList : [Project]{
        return self.projectList
    }
    
    public var getPointer : Int {
        return self.pointer
    }
    
    public func addProject(project : Project){
        self.projectList.append(project)
    }
    
}
