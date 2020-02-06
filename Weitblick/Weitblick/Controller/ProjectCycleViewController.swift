//
//  ProjectCycleViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 06.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit


class ProjecCycleViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    var projectList : [Project] = []
    var date = Date.init()
    var projectListCycle : [Project] = []
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectListCycle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"project_cycle_cell", for: indexPath)as! ProjectCycleCell
        
        print("IN TABLE VIEW CELL")
        
        cell.project_title.text = projectListCycle[indexPath.row].getName
        cell.project_location.text = projectListCycle[indexPath.row].getLocation.getAddress
        //cell.project_partner.text = projectList[indexPath.row].getHosts[0]
        cell.project_image!.image = projectListCycle[indexPath.row].getImage
        
        print(projectListCycle[indexPath.row].getName)
        
        return cell
    }
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            print("IN VIEW DID LOAD")
            
            DataService.loadProjects(date: self.date) { (list) in
                       self.projectList = list
                       self.date = self.projectList.last?.getPublished ?? self.date
                      // DispatchQueue.main.async {
                       //    self.tableView.reloadData()
                           for project in self.projectList{
                            if(!project.getCycleObject.getDonations.isEmpty){
                                print("IN append to CycleList")
                                self.projectListCycle.append(project)
                            }
                              
                               
                         //  }
                       }
                   }
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
    }
    
    
}
