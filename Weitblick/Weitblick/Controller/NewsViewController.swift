//
//  NewsViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 04.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

extension Date{
    func dateAndTimetoString(format: String = "dd.MM.yyyy") -> String {
    let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.dateFormat = format
    return formatter.string(from: self)
        }
}

extension Date{
    func dateAndTimetoStringUS(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{


    var imagesLoaded : Bool = false
    var postCount : Int = 5
    var count : Int = 0
    var newsList : [NewsEntry] = []
    var news_title = ""
    var news_description = ""
    var news_location = ""
    var news_date = ""
    var news_object : NewsEntry?
    var date = Date.init()
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
        cell.news_image.image = newsList[indexPath.row].getImage
        // TODO If TEASER = NIL OR ""
        cell.news_date.text = newsList[indexPath.row].getCreationDate.dateAndTimetoString()
        // TODO If TEASER = NIL OR ""
        cell.news_description.text = newsList[indexPath.row].getTeaser.html2String
        cell.news_description.sizeToFit()
        cell.news_title.text = newsList[indexPath.row].getTitle.html2String
        cell.news_title.sizeToFit()
        cell.news_button_detail.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.news_object = newsList[indexPath.row]
        self.performSegue(withIdentifier: "goToNewsDetail", sender: self)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.newsList.count - 1
        if ((indexPath.row) == lastElement) {
            DataService.loadNews(date: self.date) { (list) in
                for newsEntry in list{
                    self.newsList.append(newsEntry)
                }
                self.date = self.newsList.last!.getCreationDate
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }



override func viewDidLoad() {
    super.viewDidLoad()
    DataService.loadNews(date: self.date) { (list) in
        self.newsList = list
        self.date = self.newsList.last!.getCreationDate
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
    }
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewsDetailViewController{
            let newsDetailViewController = segue.destination as? NewsDetailViewController
            newsDetailViewController?.news_object = self.news_object
        }
    }

    public func downloadData(){
    var resultimages : [Image] = []
    let url = NSURL(string: "https://new.weitblicker.org/rest/news/?limit=3")
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

                    guard let Dictteaser = newsDict.value(forKey: "teaser") else { return }
                    let newsTeaser = Dictteaser as! String

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
                    let newsEntry = NewsEntry(id: newsID!, title: newsTitle, text: newsText, gallery: resultGallery, created: newsCreated , updated: newsUpdated, range: newsRange, image: imageItem, teaser: newsTeaser)
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


/*

let regex = try! NSRegularExpression(pattern: "!\\[(.*?)\\]\\((.*?)\\\"")
let string = ""


*/
