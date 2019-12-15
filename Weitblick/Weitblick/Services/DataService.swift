//
//  DataService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 04.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class DataService{
    
    static func loadNews(date : Date,completion: @escaping (_ newsList : [NewsEntry]) -> ()){
        var newsList : [NewsEntry] = []
        var resultimages : [UIImage] = []
        

        let timestamp = date.dateAndTimetoStringISO()
        let url = NSURL(string: "https://new.weitblicker.org/rest/news/?end="+timestamp+"&limit=3")
        let str = "surfer:hangloose"
        let dataB64 = Data(str.utf8).base64EncodedString();
        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + dataB64, forHTTPHeaderField: "Authorization")
        
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
                    var newsText = text as! String
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
                    var image : UIImage
                    if(imageURL == ""){
                        let size = CGSize.init(width: 334, height: 176)
                        image = UIImage(named: "Weitblick")!.crop(to: size)
                    }else{
                        let imgURL = NSURL(string : Constants.url + imageURL)
                        let data = NSData(contentsOf: (imgURL as URL?)!)
                        image = UIImage(data: data! as Data)!
                        
                    }
                    
                    guard let updated = newsDict.value(forKey: "updated") else { return }
                    let upDatedString = updated as! String
                    let newsUpdated = self.handleDate(date: upDatedString)
                    
                    guard let range = newsDict.value(forKey: "range") else { return }
                    let newsRange = range as! String
                    
                    guard let Dictteaser = newsDict.value(forKey: "teaser") else { return }
                    let newsTeaser = Dictteaser as! String
                    
                    guard let gallery = newsDict.value(forKey: "photos") else { return }
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
                    
                    let newsEntry = NewsEntry(id: newsID!, title: newsTitle, text: newsText, gallery: resultimages, created: newsCreated , updated: newsUpdated, range: newsRange, image: image, teaser: newsTeaser)
                    resultimages = []
                    newsList.append(newsEntry)
                }
            }
            completion(newsList)
        }
        }).resume()
        
    }
    
    static func getProjectWithID (id: Int, completion: @escaping (_ project: Project) -> ()){

        var resultimages : [UIImage] = []
        var projectReturn : Project?
        let string = Constants.projectURL + id.description + "/"
        //print(string)
        let url = NSURL(string: string)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var task = URLRequest(url:url! as URL)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        let request = URLSession.shared.dataTask(with: task){(data, response, error) in
            let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let projectDict = jsondata as? NSDictionary{
                guard let id = projectDict.value(forKey: "id")  else { return }
                let IDString = id as! String
                let projectID = Int.init(IDString)
                guard let title = projectDict.value(forKey: "name") else { return }
                let projectTitle = title as! String
                
                guard let imageURLJSON = projectDict.value(forKey : "image") else { return }
                var imageURL = ""
                if let mainImageDict = imageURLJSON as? NSDictionary{
                    guard let imgURL = mainImageDict.value(forKey: "url") else { return }
                    imageURL = imgURL as! String
                }
                var image : UIImage
                if(imageURL == ""){
                    let size = CGSize.init(width: 334, height: 176)
                    image = UIImage(named: "Weitblick")!.crop(to: size)
                }else{
                    let imgURL = NSURL(string : Constants.url + imageURL)
                    let data = NSData(contentsOf: (imgURL as URL?)!)
                    image = UIImage(data: data! as Data)!
                    
                }
                guard let description = projectDict.value(forKey: "description") else { return }
                var projectDescription = description as! String
                projectDescription = extractRegex(input: projectDescription, regex: DataService.matches(for: Constants.regexReplace, in: projectDescription))
                guard let locationJSON = projectDict.value(forKey: "location") else { return }
                var location : Location = Location()
                if let locationDict = locationJSON as? NSDictionary{
                    guard let id = locationDict.value(forKey: "id")  else { return }
                    let IDString = id as! String
                    let locationID = Int.init(IDString)
                    guard let lat = locationDict.value(forKey: "lat")  else { return }
                    let latNumber = lat as! NSNumber
                    let locationLat = Double.init(latNumber)
                    guard let lng = locationDict.value(forKey: "lng")  else { return }
                    let lngNumber = lng as! NSNumber
                    let locationLng = Double.init(lngNumber)
                    guard let address = locationDict.value(forKey: "address")  else { return }
                    let locationAddress = address as! String
                    location = Location(id: locationID!, lat: locationLat, lng: locationLng, address: locationAddress)
                }
                guard let published = projectDict.value(forKey: "published") else { return }
                let projectPublished = Date()
                guard let hosts = projectDict.value(forKey: "hosts") else { return }
                let resultHosts = hosts as! [String]
                
                guard let gallery = projectDict.value(forKey: "photos") else { return }
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
                
                
                projectReturn =  Project(id: projectID!, published: projectPublished, name: projectTitle, image: image, gallery: resultimages, hosts: resultHosts, description: projectDescription, location: location , partnerID: [], cycleID:[] )
                resultimages = []
                completion(projectReturn!)
            }
        }
        request.resume()
    
}



static func loadProjects(date : Date,completion: @escaping (_ projectList : [Project]) -> ()){
        var projectList : [Project] = []
        var resultimages : [UIImage] = []
        // /rest/news?start=2019-10-01&end=2020-01-01&limit=30
        //let url = NSURL(string: Constants.restURL + "?start=1970-01-01&end="+date.dateAndTimetoStringUS()+"&limit=3")
        let timestamp = date.dateAndTimetoStringUS()
        let url = NSURL(string: "https://new.weitblicker.org/rest/projects/")
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
                    guard let imageURLJSON = projectDict.value(forKey : "image") else { return }
                    var imageURL = ""
                    if let mainImageDict = imageURLJSON as? NSDictionary{
                        guard let imgURL = mainImageDict.value(forKey: "url") else { return }
                        imageURL = imgURL as! String
                    }
                    var image : UIImage
                    if(imageURL == ""){
                        let size = CGSize.init(width: 334, height: 176)
                        image = UIImage(named: "Weitblick")!.crop(to: size)
                    }else{
                        let imgURL = NSURL(string : Constants.url + imageURL)
                        let data = NSData(contentsOf: (imgURL as URL?)!)
                        image = UIImage(data: data! as Data)!
                        
                    }
                    guard let description = projectDict.value(forKey: "description") else { return }
                    var projectDescription = description as! String
                    projectDescription = extractRegex(input: projectDescription, regex: DataService.matches(for: Constants.regexReplace, in: projectDescription))
                    guard let locationJSON = projectDict.value(forKey: "location") else { return }
                    var location : Location = Location()
                    if let locationDict = locationJSON as? NSDictionary{
                        print(locationDict)
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
                   //self.locationListID.append(projectLocationID)
                   //guard let partner = projectDict.value(forKey: "partner") else { return }
                   guard let published = projectDict.value(forKey: "published") else { return }
                    let projectPublished = Date()// self.handleDate(date: publishedString)
                   guard let hosts = projectDict.value(forKey: "hosts") else { return }
                   let resultHosts = hosts as! [String]

                    guard let gallery = projectDict.value(forKey: "photos") else { return }
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
                    
                    let project = Project(id: projectID!, published: projectPublished, name: projectTitle, image: image, gallery: resultimages, hosts: resultHosts, description: projectDescription, location: location , partnerID: [], cycleID:[] )
                    projectList.append(project)
                    resultimages = []
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
        let input2 = input1[input1.count-1].split(separator: " ")
        return input2.first!.description
    }
    
    static func getURLfromGivenRegexProjects(input : String) -> String{
        let input1 = input.split(separator: "(")
        let input2 = input1[1].split(separator: ")")
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
            let r = results.map {
                String(text[Range($0.range, in: text)!])
            }
            return r
            
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
    
    static func getImageURLSFromProjects(string : String ,completion: @escaping (_ urlList : [String]) -> ()){
        var returnStrings :  [String] = []
        returnStrings = DataService.matches(for: Constants.regexReplace, in: string)
        completion(returnStrings)
    }
    
    
}



