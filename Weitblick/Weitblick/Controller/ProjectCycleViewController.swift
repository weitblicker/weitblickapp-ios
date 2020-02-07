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
    var date = Date.init()
    var projectListCycle : [Project] = []
    

    var counter = 0
    
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
  
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ProjectCycleCount")
       print(self.projectListCycle.count)
        return self.projectListCycle.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier:"project_cycle_cell", for: indexPath)as! ProjectCycleCell
           
           print("IN TABLE VIEW CELL")
           
       
               cell.project_title.text = projectListCycle[indexPath.row].getName
              cell.project_location.text = projectListCycle[indexPath.row].getLocation.getAddress
              //cell.project_partner.text = projectList[indexPath.row].getHosts[0]
               cell.project_image!.image = projectListCycle[indexPath.row].getImage
        
        cell.project_cycle_button.addTarget(self, action: #selector(ProjectCycleViewController.goToCycle), for: .touchUpInside)
        cell.project_cycle_button.tag = indexPath.row
        
        print(projectListCycle[indexPath.row].getName)
           
           
           
           
           return cell
       }
    
    @objc func goToCycle(sender:UIButton!){
           
           print("IN GOTOCYCLE")
           let projectID = self.projectList[sender.tag].getID
           let projectName = self.projectList[sender.tag].getName

           UserDefaults.standard.set(projectID, forKey: "projectID")
           UserDefaults.standard.set(projectName, forKey: "projectName")
           self.tabBarController?.selectedIndex = 2
           
       }
    
    
    
    
    
    //
    //  ProjectViewController.swift
    //  Weitblick
    //
    //  Created by Jana  on 31.10.19.
    //  Copyright © 2019 HS Osnabrueck. All rights reserved.
    //

   
     /*   var count = 0;
        var postCount = 3;
        var projectList : [Project] = []
        var locationList : [Location] = []
        var locationListID : [Int] = []
       
        var project_object : Project?
        var delegate = ProjectTableViewCell?.self
        
        @IBOutlet weak var triangle: UILabel!
        //    var count2 = 0
    //    var postCount2 = 3
        var date = Date.init()


       
        @IBOutlet weak var tableView: UITableView!
        var clicked = 0
        
        

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return projectList.count
        }

        func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {   // Mit dequeueReusableCell werden Zellen gemäß        der im Storyboard definierten Prototypen erzeugt
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "project_cycle_cell", for: indexPath) as! ProjectCycleCell
            if(self.projectList[indexPath.row].getCycleObject.getDonations.isEmpty){
         

            }else{
                cell.project_image.image = self.projectList[indexPath.row].getImage
                 cell.project_title.text = projectList[indexPath.row].getName
                 cell.project_location.text = projectList[indexPath.row].getLocation.getAddress
              /*  cell.project_button_bike.tag = indexPath.row
                cell.project_button_bike.alpha = 1
                cell.project_button_bike.addTarget(self, action: #selector(ProjectViewController.goToCycle), for: .touchUpInside)
                cell.project_button_bike.tag = indexPath.row*/
            }
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.project_object = projectList[indexPath.row]
            self.performSegue(withIdentifier: "goToProjectDetail", sender: self)
        }
        
        
     
        
        
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        print("anno selected!")
    //        return MKAnnotationView(annotation: annotation, reuseIdentifier: "annoDefault")
    //    }


        override func viewDidLoad() {
            super.viewDidLoad()
            
             DataService.loadProjects(date: self.date) { (list) in
                self.projectList = list
                self.date = self.projectList.last?.getPublished ?? self.date
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                 
                }
            }
           
            self.tableView.delegate = self
            self.tableView.dataSource = self
              tableView.rowHeight = UITableView.automaticDimension
              tableView.estimatedRowHeight = 600
          }

        private func handleDate(date : String) -> Date{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            return dateFormatter.date(from:date) ?? Date.init()
        }

        public func getLocationAddressWithID( id :Int) -> String{
            for location in self.locationList{
                if(location.getID == id){
                    return location.getAddress
                }
            }
            return "Adress not found"
        }


        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                  if segue.destination is ProjectDetailViewController
                  {
                      let projectDetailViewController = segue.destination as? ProjectDetailViewController
                      projectDetailViewController?.project_object = self.project_object
                      projectDetailViewController?.count = self.count

                  }
            
              }
        
        
        @objc func goToCycle(sender:UIButton!){
            
            
            let projectID = self.projectList[sender.tag].getID
            let projectName = self.projectList[sender.tag].getName

            UserDefaults.standard.set(projectID, forKey: "projectID")
            UserDefaults.standard.set(projectName, forKey: "projectName")
            self.tabBarController?.selectedIndex = 2
            
        }*/
        
        
       
        


    

    
    
}
