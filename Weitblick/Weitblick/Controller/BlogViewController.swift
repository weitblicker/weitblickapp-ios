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

    @IBOutlet weak var tableView: UITableView!


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier:"blog_cell", for: indexPath)as! BlogTableViewCell


        let defaultstring = "https://new.weitblicker.org"

        if(count < postCount){
            if(self.blogList[indexPath.row].getImageMainURL == "default"){
                cell.blog_image.image = UIImage(named: "Weitblick")
            }else{
                let imgURL = NSURL(string : defaultstring + self.blogList[indexPath.row].getImageMainURL)
                if(imgURL != nil){
                    let data = NSData(contentsOf: (imgURL as URL?)!)
                    cell.blog_image.image = UIImage(data: data! as Data)
                    image?.image = UIImage(data: data! as Data)
                }
            }
            count += 1

        }
       // cell.blog_description.text = blogList[indexPath.row].getTeaser
       // cell.blog_description.sizeToFit()
        cell.blog_date.text = blogList[indexPath.row].getCreationDate.dateAndTimetoString()
        cell.blog_title.text = blogList[indexPath.row].getTitle
        cell.blog_title.sizeToFit()
        cell.blog_button_detail.tag = indexPath.row
        return cell


    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.blog_object = blogList[indexPath.row]
        self.performSegue(withIdentifier: "goToBlogDetail", sender: self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadData()
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
        var resultimages : [Image] = []
        let url = NSURL(string: "https://new.weitblicker.org/rest/blog/?limit=3")
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
            let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            print("1")
            if let newsArray = jsondata as? NSArray{
                for news in newsArray{
                    if let blogDict = news as? NSDictionary{
                        print("2")
                        guard let id = blogDict.value(forKey: "id")  else { return }
                        let IDString = id as! String
                        let blogID = Int.init(IDString)
print("3")
                        guard let title = blogDict.value(forKey: "title") else { return }
                        let blogTitle = title as! String
print("4")
                        guard let text = blogDict.value(forKey: "text") else { return }
                        let blogText = text as! String
print("5")
                        guard let created = blogDict.value(forKey: "published") else { return }
                        let createdString = created as! String
                        let blogCreated = self.handleDate(date: createdString)
                        print("6")
                        var blogURL = "default"
                        if let imageURLJSON = blogDict.value(forKey : "image"){
                            if let mainImageDict = imageURLJSON as? NSDictionary{
                                guard let imgURL = mainImageDict.value(forKey: "url") else { return }
                                blogURL = imgURL as! String
                            }
                        }
                        print("7")

                        guard let updated = blogDict.value(forKey: "updated") else { return }
                        let upDatedString = updated as! String
                        let blogUpdated = self.handleDate(date: upDatedString)
print("8")
                        guard let range = blogDict.value(forKey: "range") else { return }
                        let blogRange = range as! String
print("9")
                        guard let Dictteaser = blogDict.value(forKey: "teaser") else { return }
                        let blogTeaser = Dictteaser as! String
                        print("10")
                        print("11")
                        if let gallery = blogDict.value(forKey: "gallery"){
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
                        }
                        // Gallery
                        let resultGallery = Gallery(images: resultimages)
                        resultimages = []
                        let blogEntry = BlogEntry(id: blogID!, title: blogTitle, text: blogText, gallery: resultGallery, created: blogCreated, updated: blogUpdated, image: blogURL, teaser: blogTeaser, range: blogRange)
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
