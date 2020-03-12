//
//  ProjectCycleViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 06.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit


class ProjectCycleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate {
    
    var projectList : [Project] = []
    var project_object : Project?
    var date = Date.init()
    var projectListCycle : [Project] = []
    var viewController : BikeViewController?

    var counter = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            DataService.loadProjects(date: self.date) { (list) in
                       self.projectList = list
                       self.date = self.projectList.last?.getPublished ?? self.date
                      // DispatchQueue.main.async {
                       //    self.tableView.reloadData()
                           for project in self.projectList{
                            if(!project.getCycleObject.getDonations.isEmpty){
                                print("In append to CycleList")
                                self.projectListCycle.append(self.projectList[self.counter])
                                print(self.projectListCycle[0].getName)

                            }
                            self.counter = self.counter + 1
                            
                           DispatchQueue.main.async {
                            self.tableView.dataSource = self
                             self.tableView.delegate = self
                            self.tableView.reloadData()
                            }
                              
                               
                           }
             
                       }
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.project_object = self.projectListCycle[indexPath.row]
           self.performSegue(withIdentifier: "goToProjectDetail", sender: self)
       }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ProjectCycleCount")
       print(self.projectListCycle.count)
        return self.projectListCycle.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier:"project_cycle_cell", for: indexPath)as! ProjectCycleCell
           
           print("IN TABLE VIEW CELL")
          cell.project_cycle_button.tag = indexPath.row
           
       
               cell.project_title.text = projectListCycle[indexPath.row].getName
              cell.project_location.text = projectListCycle[indexPath.row].getLocation.getAddress
        cell.project_partner.text = projectList[indexPath.row].getHosts[0].getCity.uppercased()
               cell.project_image!.image = projectListCycle[indexPath.row].getImage
        cell.project_cycle_button.addTarget(self, action: #selector(ProjectCycleViewController.goToCycle), for: .touchUpInside)
        cell.project_cycle_button.tag = indexPath.row
        
        print(projectListCycle[indexPath.row].getName)
           
           
           
           
           return cell
       }
    
    @objc func goToCycle(sender:UIButton!){
           
        print("IN GOTOCYCLE")
        let projectID = self.projectListCycle[sender.tag].getID
        let projectName = self.projectListCycle[sender.tag].getName
        //let nameAlt = "Test"
        UserDefaults.standard.set(projectID, forKey: "projectID")
        UserDefaults.standard.set(projectName, forKey: "projectName")
        self.viewController?.updateTitle(completion: { (answer) in
            if(answer){
                DispatchQueue.main.async {
                     self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.destination is ProjectDetailViewController
          {
              let projectDetailViewController = segue.destination as? ProjectDetailViewController
              projectDetailViewController?.project_object = self.project_object
          //    projectDetailViewController?.count = self.count

          }
    
      }
    
}
    
