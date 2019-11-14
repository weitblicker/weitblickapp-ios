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


    @IBOutlet weak var tableView: UITableView!


   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return projectList.count    }

    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {   // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableViewCell
        let defaultstring = "https://new.weitblicker.org"
        if(count < postCount){
            let imgURL = NSURL(string : defaultstring + self.projectList[indexPath.row].getImageURL(index: count))
            if(imgURL != nil){
                let data = NSData(contentsOf: (imgURL as URL?)!)
                cell.project_image.image = UIImage(data: data! as Data)
            }
            count += 1

        }
        cell.project_title.text = projectList[indexPath.row].getName


        cell.project_description.text = projectList[indexPath.row].getDescription
        cell.project_button_detail.tag = indexPath.row

//        guard case let cell.project_location.text = self.getLocationAddressWithID(id: self.locationList[indexPath.row].getID) else { return cell}



      return cell
    }

        // Zelle konfigurieren
       // cell.project_title.text = fruit
        print(fruit)
        cell.imageView?.image = UIImage(named:"Weitblick")
        cell.project_title.text = fruit
        cell.project_description.text = fruit
        cell.project_location.text = fruit
        cell.project_button_detail.tag = indexPath.row
        cell.project_button_detail.addTarget(self, action: #selector(showDetail(sender:)), for: .touchUpInside)

       // cell.project_title.text = projectList[indexPath.row].getName
      //  print(cell.project_title.text ?? " ERROR")
       // cell.project_location.text = projectList[indexPath.row]
      //  cell.project_description.text = projectList[0].getDescription
      //  print(cell.project_description.text ?? "ERROR ")

      return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
          tableView.rowHeight = UITableView.automaticDimension
          tableView.estimatedRowHeight = 600
      }

    private func handleDate(date : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        print("/n/n/n")
        print(dateFormatter.date(from:date))
        print("/n/n/n")

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

    public func loadLocations(){
        let url = NSURL(string: "https://new.weitblicker.org/rest/locations/?format=json")
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
            let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let locationsArray = jsondata as? NSArray{
                for location in locationsArray{
                    if let locationDict = location as? NSDictionary{
                        guard let id = locationDict.value(forKey: "id")  else { return }
                        let IDString = id as! String
                        let locationID = Int.init(IDString)
                        guard let name = locationDict.value(forKey: "name")  else { return }
                        let locationName = name as! String
                        guard let description = locationDict.value(forKey: "description")  else { return }
                        guard let locationDescription = description as? String else { return }
                        guard let lat = locationDict.value(forKey: "lat")  else { return }
                        let locationLatString = lat as! String
                        let locationLatInt = Int.init(locationLatString)
                        let locationLatFloat = Float.init(locationLatInt!)
                        guard let lng = locationDict.value(forKey: "lng")  else { return }
                        let locationLngString = lng as! String
                        let locationLngInt = Int.init(locationLngString)
                        let locationLngFloat = Float.init(locationLngInt!)
                        guard let address = locationDict.value(forKey: "address") else { return }
                        let locationAddress = address as! String
                        let location = Location(id: locationID!, name: locationName, description: locationDescription, lat: locationLatFloat, lng: locationLngFloat, address: locationAddress)
                        self.locationList.append(location)
                    }
                }
            }
        }).resume()
    }

     public func downloadData(){
        var resultPartnerID : [Int] = []
        var resultHosts : [String] = []
         var resultimages : [Image] = []
         let url = NSURL(string: "https://new.weitblicker.org/rest/projects/?format=json&limit=3")
         let str = "surfer:hangloose"
         let test2 = Data(str.utf8).base64EncodedString();
         var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
         task.httpMethod = "GET"
         task.addValue("application/json", forHTTPHeaderField: "Content-Type")
         task.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")

         URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
             let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
             if let projectArray = jsondata as? NSArray{
                 for project in projectArray{
                     if let projectDict = project as? NSDictionary{
                         guard let id = projectDict.value(forKey: "id")  else { return }
                         let IDString = id as! String
                         let projectID = Int.init(IDString)

                         guard let title = projectDict.value(forKey: "name") else { return }
                         let projectTitle = title as! String

                         guard let description = projectDict.value(forKey: "description") else { return }
                         let projectDescription = description as! String

                        guard let location = projectDict.value(forKey: "location") else { return }
                        let projectLocationID = location as! Int

                        //guard let partner = projectDict.value(forKey: "partner") else { return }


                        guard let published = projectDict.value(forKey: "published") else { return }
                         let publishedString = published as! String
                         let projectPublished = self.handleDate(date: publishedString)
                        guard let hosts = projectDict.value(forKey: "hosts") else { return }
                        resultHosts = hosts as! [String]
                        guard let gallery = projectDict.value(forKey: "gallery") else { return }
                         // Gallery
                         if let imageDict = gallery as? NSDictionary{
                             guard let images = imageDict.value(forKey : "images") else { return }
                             // Images
                             if let imageArray = images as? NSArray{
                                 for imgUrls in imageArray{
                                     if let imgDict = imgUrls as? NSDictionary{
                                         guard let url = imgDict.value(forKey : "url") else { return }
                                         let img = Image(imageURL: (url as! String))
                                         resultimages.append(img)
                                     }
                                 }
                             }
                         }
                         let resultGallery = Gallery(images: resultimages)
                         resultimages = []
                        let project = Project(id: projectID!, published: projectPublished, name: projectTitle, gallery: resultGallery, hosts: resultHosts, description: projectDescription, locationID: projectLocationID, partnerID: [])
                        resultPartnerID = []
                        self.projectList.append(project)
                        }
                 }
                 // Do after Loading
                 OperationQueue.main.addOperation {
                    self.loadLocations()
                    self.tableView.reloadData()
                 }

             }
             }).resume()
     }







}
