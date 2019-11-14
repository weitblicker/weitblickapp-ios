//
//  NewsViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 04.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{


    var imagesLoaded : Bool = false
    var postCount : Int = 3
    var count : Int = 0
    var newsList : [NewsEntry] = []
    @IBOutlet weak var tableView: UITableView!



     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }

     func tableView(_ tableView: UITableView,
                             cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier:"news_cell", for: indexPath)as! NewsTableViewCell
        // Zelle konfigurieren
        let defaultstring = "https://new.weitblicker.org"

       // let imgURL = NSURL(string : defaultstring + tabbar.newsCollection.getNewsList[indexPath.row].getImageURL)
        if(count < postCount){
            let imgURL = NSURL(string : defaultstring + self.newsList[indexPath.row].getImageURL)
            if(imgURL != nil){
                let data = NSData(contentsOf: (imgURL as URL?)!)
                cell.news_image.image = UIImage(data: data! as Data)
            }
            count += 1

        }
//        let imgURL = NSURL(string : defaultstring + self.newsList[indexPath.row].getImageURL)
        //print(imgURL)
//        let location : Location = getLocation(InputId: self.newsList[indexPath.row].g)



        //cell.news_description.text = tabbar.newsCollection.getNewsList[indexPath.row].getTitle
        cell.news_date.text = newsList[indexPath.row].getCreationDate.description

        cell.news_description.text = newsList[indexPath.row].getTitle
        cell.news_button_detail.tag = indexPath.row

        return cell
    }

override func viewDidLoad() {
    super.viewDidLoad()
    self.downloadData()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 600
}
    private func handleDate(date : String) -> Date{
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
       dateFormatter.locale = Locale(identifier: "en_US_POSIX")
       return dateFormatter.date(from:date)!
   }

    public func getLocation (InputId : Int) -> Location{
        var resultLocation = Location(id: 0, name: "", description: "", lat: 0.0, lng: 0.0, address: "")
        let url = NSURL(string: "https://new.weitblicker.org/rest/locations")
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
                    if(locationID ==  InputId){
                        guard let name = locationDict.value(forKey: "name")  else { return }
                        let locationName = name as! String
                        guard let description = locationDict.value(forKey: "description")  else { return }
                        let locationDescription = description as! String
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

                        resultLocation = Location(id: locationID!, name: locationName, description: locationDescription, lat: locationLatFloat, lng: locationLngFloat, address: locationAddress)
                    }
                }
            }
        }
    })
    return resultLocation
    }

    public func downloadData(){
        var resultimages : [Image] = []
        let url = NSURL(string: "https://new.weitblicker.org/rest/news/?format=json&limit=3")
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
                    if let newsDict = news as? NSDictionary{
                        guard let id = newsDict.value(forKey: "id")  else { return }
                        let IDString = id as! String
                        let newsID = Int.init(IDString)

                        guard let title = newsDict.value(forKey: "title") else { return }
                        let newsTitle = title as! String

                        guard let text = newsDict.value(forKey: "text") else { return }
                        let newsText = text as! String

                        guard let created = newsDict.value(forKey: "added") else { return }
                        let createdString = created as! String
                        let newsCreated = self.handleDate(date: createdString)

                        guard let imageURLJSON = newsDict.value(forKey : "image") else { return }
                        var imageURL = ""
                        if let mainImageDict = imageURLJSON as? NSDictionary{
                            guard let imgURL = mainImageDict.value(forKey: "url") else { return }
                            imageURL = imgURL as! String
                        }

                        guard let updated = newsDict.value(forKey: "updated") else { return }
                        let upDatedString = updated as! String
                        let newsUpdated = self.handleDate(date: upDatedString)

                        guard let range = newsDict.value(forKey: "range") else { return }
                        let newsRange = range as! String

                        guard let gallery = newsDict.value(forKey: "gallery") else { return }
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
                        let imageItem = Image(imageURL: imageURL)
                        let newsEntry = NewsEntry(id: newsID!, title: newsTitle, text: newsText, gallery: resultGallery, created: newsCreated , updated: newsUpdated, range: newsRange, image: imageItem)
                        self.newsList.append(newsEntry)
                    }
                }
                // Do after Loading
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }

            }
            }).resume()
    }
}
