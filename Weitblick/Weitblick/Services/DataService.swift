//
//  DataService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 04.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

struct Constants{
    static let restURL  = "https://new.weitblicker.org/rest"
    static let mediaURL = "https://new.weitblicker.org/media"
    static let regex = "!\\[(.*?)\\]\\((.*?)\\\""
    static let regexReplace = "!\\[(.*?)\\]\\((.*?)\\)"
    
}

class DataService{
    
    static func loadNews(date : Date,completion: @escaping (_ newsList : [NewsEntry]) -> ()){
        var newsList : [NewsEntry] = []
        var resultimages : [Image] = []
        // /rest/news?start=2019-10-01&end=2020-01-01&limit=30
        //let url = NSURL(string: Constants.restURL + "?start=1970-01-01&end="+date.dateAndTimetoStringUS()+"&limit=3")
        let timestamp = date.dateAndTimetoStringUS()
        let url = NSURL(string: "https://new.weitblicker.org/rest/news/?end="+timestamp+"&limit=3")
        //print(Constants.restURL + "/news?end="+date.dateAndTimetoStringUS()+"&limit=3")
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        //print(test2)
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
                    //print(newsTitle)
                    guard let text = newsDict.value(forKey: "text") else { return }
                    var newsText = text as! String
                    DataService.getImageURLS(string: newsText) { (list) in
                        for listItem in list {
                            let i = Image(imageURL: getURLfromGivenRegex(input: listItem))
                            resultimages.append(i)
                        }
                    }
                    newsText = extractRegex(input: newsText, regex: DataService.matches(for: Constants.regexReplace, in: newsText))
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
//                    guard let gallery = newsDict.value(forKey: "gallery") else { return }
//                    print("10")// Gallery
//                    if let imageDict = gallery as? NSDictionary{
//                        guard let images = imageDict.value(forKey : "images") else { return }
//                        // Images
//                        if let imageArray = images as? NSArray{
//                            for imgUrls in imageArray{
//                                if let imgDict = imgUrls as? NSDictionary{
//                                    guard let url = imgDict.value(forKey : "url") else { return }
//                                    let img = Image(imageURL: (url as! String))
//                                    resultimages.append(img)
//                                }
//                            }
//                        }
//                    }
                    let resultGallery = Gallery(images: resultimages)
                    resultimages = []
                    let imageItem = Image(imageURL: imageURL)
                    let newsEntry = NewsEntry(id: newsID!, title: newsTitle, text: newsText, gallery: resultGallery, created: newsCreated , updated: newsUpdated, range: newsRange, image: imageItem, teaser: newsTeaser)
                    newsList.append(newsEntry)
                }
            }
            completion(newsList)
        }
        }).resume()
        
    }
    
    
    
    static func loadProjects(date : Date,completion: @escaping (_ projectList : [Project]) -> ()){
            var projectList : [Project] = []
            var resultimages : [Image] = []
            // /rest/news?start=2019-10-01&end=2020-01-01&limit=30
            //let url = NSURL(string: Constants.restURL + "?start=1970-01-01&end="+date.dateAndTimetoStringUS()+"&limit=3")
            let timestamp = date.dateAndTimetoStringUS()
            let url = NSURL(string: "https://new.weitblicker.org/rest/projects/?&limit=3")
            //print(Constants.restURL + "/news?end="+date.dateAndTimetoStringUS()+"&limit=3")
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
                        var projectDescription = description as! String
                        DataService.getImageURLS(string: projectDescription) { (list) in
                            for listItem in list {
                                print(getURLfromGivenRegex(input: listItem))
                                let i = Image(imageURL: listItem)
                                resultimages.append(i)
                            }
                        }
                        projectDescription = extractRegex(input: projectDescription, regex: DataService.matches(for: Constants.regexReplace, in: projectDescription))
                       guard let location = projectDict.value(forKey: "location") else { return }
                       let projectLocationID = location as! Int
                       //self.locationListID.append(projectLocationID)
                       //guard let partner = projectDict.value(forKey: "partner") else { return }
                       guard let published = projectDict.value(forKey: "published") else { return }
                        let publishedString = published as! String
                        let projectPublished = Date()// self.handleDate(date: publishedString)
                       guard let hosts = projectDict.value(forKey: "hosts") else { return }
                       let resultHosts = hosts as! [String]
//                       guard let gallery = projectDict.value(forKey: "gallery") else { return }
//                        // Gallery
//                        if let imageDict = gallery as? NSDictionary{
//                            guard let images = imageDict.value(forKey : "images") else { return }
//                            // Images
//                            if let imageArray = images as? NSArray{
//                                for imgUrls in imageArray{
//                                    if let imgDict = imgUrls as? NSDictionary{
//                                        guard let url = imgDict.value(forKey : "url") else { return }
//                                        let img = Image(imageURL: (url as! String))
//                                        resultimages.append(img)
//                                    }
//                                }
//                            }
//                        }
                        let resultGallery = Gallery(images: resultimages)
                        resultimages = []
                        let project = Project(id: projectID!, published: projectPublished, name: projectTitle, gallery: resultGallery, hosts: resultHosts, description: projectDescription, locationID: projectLocationID, partnerID: [])
                       //resultPartnerID = []
                       projectList.append(project)
                    }
                }
                completion(projectList)
            }
            }).resume()
            
        }
    
    
    
    static func handleDate(date : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from:date)!
    }
    
    static func getURLfromGivenRegex(input : String) -> String{
        let input1 = input.split(separator: "(")
        let input2 = input1[1].split(separator: " ")
        return input2.first!.description
    }
    
    static func extractRegex(input: String, regex : [String]) -> String{
        var string = input
        for regexItem in regex{
            string = string.replacingOccurrences(of: regexItem, with: "")
        }
        return string
    }
    
    static func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    static func getImageURLS(string : String ,completion: @escaping (_ urlList : [String]) -> ()){
        var returnStrings :  [String] = []
        returnStrings = DataService.matches(for: Constants.regex, in: string)
        completion(returnStrings)
    }
    
}
