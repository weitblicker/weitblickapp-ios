//
//  ProjectViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import MapKit

protocol DelegateToCycle{
    func didTapProject (title: String)
}



class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, MKMapViewDelegate {
    var count = 0;
    var postCount = 3;
    var projectList : [Project] = []
    var locationList : [Location] = []
    var locationListID : [Int] = []
    var annotationList : [MKAnnotationView] = []
    var project_object : Project?
    var delegate = ProjectTableViewCell?.self
    var hostList: String = ""
    
    @IBOutlet weak var triangle: UILabel!
    //    var count2 = 0
//    var postCount2 = 3
    var date = Date.init()


    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var clicked = 0
    var counter = 0
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectList.count
    }

    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {   // Mit dequeueReusableCell werden Zellen gemäß        der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableViewCell
        
        cell.project_image.image = self.projectList[indexPath.row].getImage
        cell.project_title.text = projectList[indexPath.row].getName
        
        cell.project_city.text = projectList[indexPath.row].getHosts[0].getCity.uppercased()
        cell.project_city.font = UIFont(name: "OpenSans-Bold", size: 15)
       
        cell.project_location.text = projectList[indexPath.row].getLocation.getAddress
        cell.project_button_bike.tag = indexPath.row
        if(self.projectList[indexPath.row].getCycleObject.getDonations.isEmpty){
            cell.project_button_bike.alpha = 0
        }else{
            cell.project_button_bike.alpha = 1
            cell.project_button_bike.addTarget(self, action: #selector(ProjectViewController.goToCycle), for: .touchUpInside)
            cell.project_button_bike.tag = indexPath.row
        }
        counter = 0
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.project_object = projectList[indexPath.row]
        self.performSegue(withIdentifier: "goToProjectDetail", sender: self)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var i = 0
        for annoView in self.annotationList{
            if(annotationIsEqualTo(annotation: view.annotation!, toCompare: annoView.annotation!)){
                self.tableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.top )
            }else{
                i += 1
            }
        }
    }
    
    func annotationIsEqualTo(annotation : MKAnnotation, toCompare : MKAnnotation) -> Bool{
        if(annotation.coordinate.latitude == toCompare.coordinate.latitude){
            if(annotation.coordinate.longitude == toCompare.coordinate.longitude){
                return true
            }
        }
        return false
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        print("anno selected!")
//        return MKAnnotationView(annotation: annotation, reuseIdentifier: "annoDefault")
//    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
         triangle.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
        DataService.loadProjects(date: self.date) { (list) in
            self.projectList = list
            self.date = self.projectList.last?.getPublished ?? self.date
            DispatchQueue.main.async {
                self.tableView.reloadData()
                for project in self.projectList{
                    let CLLCoordType = CLLocationCoordinate2D(latitude: project.getLocation.getLatitude,longitude: project.getLocation.getLongitude)
                    let anno = MKPointAnnotation()
                    anno.coordinate = CLLCoordType
                    //print("Inbefore addAnnotation")
                    //self.mapView.addAnnotation(anno)
                    let annoView = MKAnnotationView(annotation: anno, reuseIdentifier: project.getName)
                    self.annotationList.append(annoView)
                    self.mapView.addAnnotation(annoView.annotation!)
                    
                }
            }
        }
        self.mapView.delegate = self
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
        
    }
    
    
   
    


}
