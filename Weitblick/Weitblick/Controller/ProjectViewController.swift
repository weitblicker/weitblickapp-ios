//
//  ProjectViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit



class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var count = 0;
    var postCount = 3;
    var projectList : [Project] = []
    var locationList : [Location] = []
    var locationListID : [Int] = []
    var project_object : Project?
//    var count2 = 0
//    var postCount2 = 3
    var date = Date.init()


    @IBOutlet weak var tableView: UITableView!


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

//    public func loadLocations(){
//        let url = NSURL(string: "https://new.weitblicker.org/rest/locations/?format=json")
//        let str = "surfer:hangloose"
//        let test2 = Data(str.utf8).base64EncodedString();
//        var task2 = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
//        task2.httpMethod = "GET"
//        task2.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        task2.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: task2, completionHandler: {(data,response,error) -> Void in
//            let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//            if let locationsArray = jsondata as? NSArray{
//                for location in locationsArray{
//                    if let locationDict = location as? NSDictionary{
//                        guard let id = locationDict.value(forKey: "id")  else { return }
//                        let IDString = id as! String
//                        let locationID = Int.init(IDString)
//                        guard let name = locationDict.value(forKey: "name")  else { return }
//                        let locationName = name as! String
//                        guard let description = locationDict.value(forKey: "description")  else { return }
//                        guard let locationDescription = description as? String else { return }
//                        guard let lat = locationDict.value(forKey: "lat")  else { return }
//                        let locationLatString = lat as! String
//                        let locationLatInt = Int.init(locationLatString)
//                        let locationLatFloat = Float.init(locationLatInt!)
//                        guard let lng = locationDict.value(forKey: "lng")  else { return }
//                        let locationLngString = lng as! String
//                        let locationLngInt = Int.init(locationLngString)
//                        let locationLngFloat = Float.init(locationLngInt!)
//                        guard let address = locationDict.value(forKey: "address") else { return }
//                        let locationAddress = address as! String
//                        let location = Location(id: locationID, lat: locationLatInt, lng: <#T##Float#>, address: <#T##String#>)
//                        self.locationList.append(location)
//
//                    }
//                }
//                OperationQueue.main.addOperation {
//                   self.tableView.reloadData()
//                }
//            }
//        }).resume()
//    }

//     public func downloadData(){
//        var resultPartnerID : [Int] = []
//        var resultHosts : [String] = []
//         var resultimages : [Image] = []
//         let url = NSURL(string: "https://new.weitblicker.org/rest/projects/?format=json&limit=3")
//         let str = "surfer:hangloose"
//         let test2 = Data(str.utf8).base64EncodedString();
//         var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
//         task.httpMethod = "GET"
//         task.addValue("application/json", forHTTPHeaderField: "Content-Type")
//         task.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
//
//         URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
//             let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//             if let projectArray = jsondata as? NSArray{
//                 for project in projectArray{
//                     if let projectDict = project as? NSDictionary{
//                         guard let id = projectDict.value(forKey: "id")  else { return }
//                         let IDString = id as! String
//                         let projectID = Int.init(IDString)
//
//                         guard let title = projectDict.value(forKey: "name") else { return }
//                         let projectTitle = title as! String
//
//                         guard let description = projectDict.value(forKey: "description") else { return }
//                         let projectDescription = description as! String
//
//                        guard let location = projectDict.value(forKey: "location") else { return }
//                        let projectLocationID = location as! Int
//                        self.locationListID.append(projectLocationID)
//                        //guard let partner = projectDict.value(forKey: "partner") else { return }
//
//
//                        guard let published = projectDict.value(forKey: "published") else { return }
//                         let publishedString = published as! String
//                         let projectPublished = self.handleDate(date: publishedString)
//                        guard let hosts = projectDict.value(forKey: "hosts") else { return }
//                        resultHosts = hosts as! [String]
//                        guard let gallery = projectDict.value(forKey: "gallery") else { return }
//                         // Gallery
//                         if let imageDict = gallery as? NSDictionary{
//                             guard let images = imageDict.value(forKey : "images") else { return }
//                             // Images
//                             if let imageArray = images as? NSArray{
//                                 for imgUrls in imageArray{
//                                     if let imgDict = imgUrls as? NSDictionary{
//                                         guard let url = imgDict.value(forKey : "url") else { return }
//                                         let img = Image(imageURL: (url as! String))
//                                         resultimages.append(img)
//                                     }
//                                 }
//                             }
//                         }
//                         let resultGallery = Gallery(images: resultimages)
//                         resultimages = []
//                        let project = Project(id: projectID!, published: projectPublished, name: projectTitle, gallery: resultGallery, hosts: resultHosts, description: projectDescription, locationID: projectLocationID, partnerID: [])
//                        resultPartnerID = []
//                        self.projectList.append(project)
//                        }
//                 }
//                 // Do after Loading
//                 OperationQueue.main.addOperation {
//                    self.tableView.reloadData()
//                 }
//
//             }
//             }).resume()
//     }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              if segue.destination is ProjectDetailViewController
              {
                  let projectDetailViewController = segue.destination as? ProjectDetailViewController
                  projectDetailViewController?.project_object = self.project_object
                projectDetailViewController?.count = self.count



              }
          }



}
