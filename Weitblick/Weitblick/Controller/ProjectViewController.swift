//
//  ProjectViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

protocol DelegateToCycle{
    func didTapProject (title: String)
}



class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate {
    var count = 0;
    var postCount = 3;
    var projectList : [Project] = []
    var locationList : [Location] = []
    var locationListID : [Int] = []
    var project_object : Project?
    var delegate = ProjectTableViewCell?.self
//    var count2 = 0
//    var postCount2 = 3
    var date = Date.init()


    @IBOutlet weak var tableView: UITableView!
    var clicked = 0


   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return projectList.count    }

    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {   // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableViewCell
        let defaultstring = "https://new.weitblicker.org"
        //if(count < postCount){
        cell.project_image.image = UIImage(named : "Weitblick")
        //let imgURL = NSURL(string : defaultstring + self.projectList[indexPath.row].getImageURL(index: count))
//            if(imgURL != nil){
//                let data = NSData(contentsOf: (imgURL as URL?)!)
//                cell.project_image.image = UIImage(data: data! as Data)
//
//            }

            //count += 1

        //}
        cell.project_title.text = projectList[indexPath.row].getName
        cell.project_location.text = projectList[indexPath.row].getLocation.getAddress
        
       // cell.subscribeButton.addTarget(self, action: #selector(subscribeTapped(_:)), for: .touchUpInside)
        print("TEST =====\n\n")
        print(project_object?.getCycleIDCount.description)
        
        cell.project_button_bike.tag = indexPath.row
        //cell.project_button_bike.addTarget(self, action: #selector("ProjectViewController.goToCycle"), for: UIControl.Event.touchUpInside)
        cell.project_button_bike.addTarget(self, action: #selector(ProjectViewController.goToCycle), for: .touchUpInside)
//
//        print(project_object?.getCycleIDCount.description)
//               if(project_object?.getCycleIDCount == 0){
//                   cell.project_button_bike.alpha = 0
//
//               } else {
//                     cell.project_button_bike.addTarget(self, action: #selector(ProjectViewController.goToCycle), for: .touchUpInside)
//                          cell.project_button_bike.tag = indexPath.row
//               }
//
        
        //let id = self.locationListID[indexPath.row]
        //let locationString = self.getLocationAddressWithID(id: id)
       // cell.project_button_detail.tag = indexPath.row

//        guard case let cell.project_location.text = self.getLocationAddressWithID(id: self.locationList[indexPath.row].getID) else { return cell}



      return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     self.project_object = projectList[indexPath.row]
     print("Index: ")
     print (indexPath.row)
     self.performSegue(withIdentifier: "goToProjectDetail", sender: self)
      
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        //self.loadLocations()
        //self.downloadData()
        print(self.date)
        DataService.loadProjects(date: self.date) { (list) in
            self.projectList = list
            print(list.count)
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
            print(id.description + " = = " + location.getID.description)
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
        
        let project = self.projectList[sender.tag]
        let tabbar = self.tabBarController as! TabBarController
        tabbar.defaultProject = project
        print("IN GO TO CYCLE")
        print(tabbar.defaultProject?.getName)
        UserDefaults.standard.set(projectID, forKey: "projectID")
        UserDefaults.standard.set(projectName, forKey: "projectName")
        self.tabBarController?.selectedIndex = 2
        
    }
   
    


}
