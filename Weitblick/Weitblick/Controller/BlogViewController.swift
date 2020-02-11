//
//  BlogViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 14.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class BlogViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

    var blogList : [BlogEntry] = []
    var count = 0
    var postCount = 3
    var blog_object : BlogEntry?
    var image: UIImageView?
    var date : Date = Date()

    
    @IBOutlet weak var tableView: UITableView!


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogList.count
    
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier:"blog_cell", for: indexPath)as! BlogTableViewCell

        cell.blog_image.image = self.blogList[indexPath.row].getImage
        cell.blog_description.text = blogList[indexPath.row].getTeaser
        cell.blog_description.sizeToFit()
        cell.blog_date.text = blogList[indexPath.row].getCreationDate.dateAndTimetoString()
        cell.blog_title.text = blogList[indexPath.row].getTitle
        cell.blog_description.text = blogList[indexPath.row].getText
        cell.triangle.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
        cell.blog_title.sizeToFit()
        if(blogList[indexPath.row].getLocation.getAddress == ""){
                  cell.blog_location_marker.alpha = 0
                  cell.blog_country.text = "     "
             
              }else{
                  cell.blog_country.text = blogList[indexPath.row].getLocation.getAddress
                  
              }
        
        //cell.blog_button_detail.tag = indexPath.row
        
       
        return cell


    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.blog_object = blogList[indexPath.row]
    self.performSegue(withIdentifier: "goToBlogDetail", sender: self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        BlogService.loadBlogs(date: self.date) { (list) in
            self.blogList = list
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
       
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    private func handleDate(date : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from:date) ?? Date.init()
    }
    
   

    public func downloadData(){
            var resultimages : [UIImage] = []
            let url = NSURL(string: "https://weitblicker.org/rest/blog/")
            let str = "surfer:hangloose"
            let test2 = Data(str.utf8).base64EncodedString();
            var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
            task.httpMethod = "GET"
            task.addValue("application/json", forHTTPHeaderField: "Content-Type")
            task.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
                let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                if let newsArray = jsondata as? NSArray{
                    for news in newsArray{
                        if let blogDict = news as? NSDictionary{
                            guard let id = blogDict.value(forKey: "id")  else { return }
                            let IDString = id as! String
                            let blogID = Int.init(IDString)
                            
                            guard let title = blogDict.value(forKey: "title") else { return }
                            let blogTitle = title as! String
                            
                            guard let text = blogDict.value(forKey: "text") else { return }
                            let blogText = text as! String
                            
                            guard let created = blogDict.value(forKey: "published") else { return }
                            let createdString = created as! String
                            let blogCreated = self.handleDate(date: createdString)
                            
                            guard let imageURLJSON = blogDict.value(forKey : "image") else { return }
                            var imageURL = ""
                            if let mainImageDict = imageURLJSON as? NSDictionary{
                                guard let imgURL = mainImageDict.value(forKey: "url") else { return }
                                imageURL = imgURL as! String
                            }
                            var image : UIImage
                            if(imageURL == ""){
                                image = UIImage(named: "Weitblick")!
                            }else{
                                let imgURL = NSURL(string : Constants.url + imageURL)
                                let data = NSData(contentsOf: (imgURL as URL?)!)
                                image = UIImage(data: data! as Data)!
                                
                            }
                            
                            var projectInt = 0
                            guard let project = blogDict.value(forKey: "project") else { return }
                            if let projectString = project as? String{
                                projectInt = Int.init(projectString)!
                            }
                            

                            guard let updated = blogDict.value(forKey: "updated") else { return }
                            let upDatedString = updated as! String
                            let blogUpdated = self.handleDate(date: upDatedString)
                            
                            guard let range = blogDict.value(forKey: "range") else { return }
                            let blogRange = range as! String
                            
                            guard let Dictteaser = blogDict.value(forKey: "teaser") else { return }
                            let blogTeaser = Dictteaser as! String
                            
                            guard let gallery = blogDict.value(forKey: "photos") else { return }
                            if let imageArray = gallery as? NSArray{
                                for img in imageArray{
                                    if let imgDict = img as? NSDictionary{
                                        guard let url = imgDict.value(forKey : "url") else { return }
                                        let urlString = url as! String
                                        let imgURL = NSURL(string : Constants.url + urlString)
                                        let data = NSData(contentsOf: (imgURL as URL?)!)
                                        let image = UIImage(data: data! as Data)!
                                        resultimages.append(image)
                                    }
                                }
                            }
                            
                            guard let locationJSON = blogDict.value(forKey: "location") else { return }
                            var location : Location = Location()
                            if let locationDict = locationJSON as? NSDictionary{
                                guard let id = locationDict.value(forKey: "id")  else { return }
                                let IDString = id as! String
                                let locationID = Int.init(IDString)
                                guard let lat = locationDict.value(forKey: "lat")  else { return }
                                let latNumber = lat as! NSNumber
                                let locationLat = Double.init(truncating: latNumber)
                                guard let lng = locationDict.value(forKey: "lng")  else { return }
                                let lngNumber = lng as! NSNumber
                                let locationLng = Double.init(truncating: lngNumber)
                                guard let address = locationDict.value(forKey: "address")  else { return }
                                let locationAddress = address as! String
                                location = Location(id: locationID!, lat: locationLat, lng: locationLng, address: locationAddress)
                            }
                            var hostObject = Host()
                            guard let host = blogDict.value(forKey: "host") else { return }
                            if let hostDict = host as? NSDictionary{
                                //init(id : Int, name : String, partners : [Int], bankAccount : BankAccount){
                                guard let hostID = hostDict.value(forKey: "id") else { return }
                                let hostIDString = hostID as! String
                                guard let hostName = hostDict.value(forKey : "name") else { return }
                                let hostNameString = hostName as! String
                                guard let city = hostDict.value(forKey: "city") else { return }
                                let cityString = city as! String
                                guard let hostPartners = hostDict.value(forKey : "partners") else { return }
                                var hostPartnerList : [Int] = []
                                if let hostPartnerArray = hostPartners as? NSArray{
                                    for hostPartner in hostPartnerArray{
                                        hostPartnerList.append(hostPartner as! Int)
                                    }
                                }
                                
                                guard let locationJSON = hostDict.value(forKey: "location") else { return }
                                var location : Location = Location()
                                if let locationDict = locationJSON as? NSDictionary{
                                    guard let id = locationDict.value(forKey: "id")  else { return }
                                    let IDString = id as! String
                                    let locationID = Int.init(IDString)
                                    guard let lat = locationDict.value(forKey: "lat")  else { return }
                                    let latNumber = lat as! NSNumber
                                    let locationLat = Double.init(truncating: latNumber)
                                    guard let lng = locationDict.value(forKey: "lng")  else { return }
                                    let lngNumber = lng as! NSNumber
                                    let locationLng = Double.init(truncating: lngNumber)
                                    guard let address = locationDict.value(forKey: "address")  else { return }
                                    let locationAddress = address as! String
                                    location = Location(id: locationID!, lat: locationLat, lng: locationLng, address: locationAddress)
                                }
                                
                                var hostbankAcc : BankAccount = BankAccount()
            //                                "account_holder": "Weitblick Münster e.V.",
            //                                "iban": "DE64400800400604958800",
            //                                "bic": "DRESDEFF400"
                                guard let hostbank = hostDict.value(forKey : "bank_account") else { return }
                                if let hostbankDict = hostbank as? NSDictionary{
                                    guard let holder = hostbankDict.value(forKey: "account_holder") else { return }
                                    let holderString = holder as! String
                                    guard let iban = hostbankDict.value(forKey: "iban") else { return }
                                    let ibanString = iban as! String
                                    guard let bic = hostbankDict.value(forKey: "bic") else { return }
                                    let bicString = bic as! String
                                    hostbankAcc = BankAccount(holder: holderString, iban: ibanString, bic: bicString)
                                }
                                hostObject = Host(id: hostIDString, name: hostName as! String, partners: hostPartnerList, bankAccount: hostbankAcc, location: location, city: cityString)
                                
                            }
                            
                            let author = Author()
                            let blogEntry = BlogEntry(id: blogID!, title: blogTitle, text: blogText, created: blogCreated, updated: blogCreated, image: image, teaser: blogTeaser, range: blogRange,gallery: resultimages, projectInt: projectInt, author : author, location: location, host: hostObject)
                            resultimages = []
                            self.blogList.append(blogEntry)
                        }
                    }
                    // Do after Loading
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }

                }
                }).resume()
        }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.destination is BlogDetailViewController
           {
               let blogDetailViewController = segue.destination as? BlogDetailViewController
               blogDetailViewController?.blog_object = self.blog_object
            blogDetailViewController?.image = self.image?.image


           }
       }




}
