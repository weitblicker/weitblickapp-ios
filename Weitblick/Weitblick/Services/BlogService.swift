//
//  BlogService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 27.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class BlogService{
    
    static func loadBlogs(date : Date,completion: @escaping (_ blogList : [BlogEntry]) -> ()){
    
        var blogList : [BlogEntry] = []
        var resultimages : [UIImage] = []
        let url = NSURL(string: "https://weitblicker.org/rest/blog/")
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        print("blog1")
        URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
            let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let newsArray = jsondata as? NSArray{
                print("blog2")
                for news in newsArray{
                    print("blog3")
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
                        let blogCreated = DataService.handleDateWithTimeZone(date: createdString)
                        
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
                        
print("blog4")
                  
                        
                        guard let range = blogDict.value(forKey: "range") else { return }
                        let blogRange = range as! String
                        
                        guard let Dictteaser = blogDict.value(forKey: "teaser") else { return }
                        let blogTeaser = Dictteaser as! String
                        
//                        if let gallery = blogDict.value(forKey: "gallery"){
//                            if let imageDict = gallery as? NSDictionary{
//                                guard let images = imageDict.value(forKey : "images") else { return }
//                                // Images
//                                if let imageArray = images as? NSArray{
//                                    for imgUrls in imageArray{
//                                        if let imgDict = imgUrls as? NSDictionary{
//                                            guard let url = imgDict.value(forKey : "url") else { return }
//                                            let img = Image(imageURL: (url as! String))
//                                            resultimages.append(img)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        // Gallery
//                        let resultGallery = Gallery(images: resultimages)
                        //resultimages = []#
                        print("blog5")
                        let blogEntry = BlogEntry(id: blogID!, title: blogTitle, text: blogText, created: blogCreated, updated: blogCreated, image: image, teaser: blogTeaser, range: blogRange)
                        blogList.append(blogEntry)
                    }
                }
                completion(blogList)

            }
            }).resume()
    }
}
