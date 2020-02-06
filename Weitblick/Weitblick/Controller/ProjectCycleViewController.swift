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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"project_cycle_cell", for: indexPath)as! ProjectCycleCell
        
        cell.project_title.text = projectList[indexPath.row].getName
        cell.project_location.text = projectList[indexPath.row].getLocation.getAddress
       // cell.project_partner.text = projectList[indexPath.row].
        cell.project_image!.image = projectList[indexPath.row].getImage
        
        return cell
    }
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
    }
    
    
}
