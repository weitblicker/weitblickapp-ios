//
//  BlogService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 27.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class BlogService{
    
    static func getBlogByID(id : Int, completion: @escaping (_ blog : BlogEntry) -> ()){
        print("IN BLOG SERVICE")
        
        var resultimages : [UIImage] = []
        let urlString = "https://weitblicker.org/rest/blog/" + id.description
        let url = NSURL(string: urlString)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
            print("Succesfull in Blog By ID\n")
        let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                if let blogDict = jsondata as? NSDictionary{
                    guard let id = blogDict.value(forKey: "id")  else { return }
                    let IDString = id as! String
                    let blogID = Int.init(IDString)
                    
                    var projectInt = 0
                    guard let project = blogDict.value(forKey: "project") else { return }
                    if let projectString = project as? NSNumber{
                        projectInt = Int.init(truncating: projectString)
                        print(projectInt.description + "\n")
                    }
                    
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
                        image = UIImage(named: "blog-defaults")!
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
                    
                    guard let author = blogDict.value(forKey: "author") else { return }
                    var authorObject = Author()
                    if let authorDict = author as? NSDictionary{
                        guard let imageURL = authorDict.value(forKey: "image") else { return }
                        var image = UIImage(named: "profileBlack100")
                        if let img = imageURL as? String{
                            let imgURL = NSURL(string : Constants.url + img)
                            let data = NSData(contentsOf: (imgURL as URL?)!)
                            image = UIImage(data: data! as Data)!
                        }
                        
                        guard let name = authorDict.value(forKey: "name") else { return }
                        let nameString = name as! String
                        
                        authorObject = Author(image: image!, name: nameString)
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
                    
                    let blogEntry = BlogEntry(id: blogID!, title: blogTitle, text: blogText, created: blogCreated, updated: blogCreated, image: image, teaser: blogTeaser, range: blogRange,gallery: resultimages, projectInt: projectInt, author : authorObject, location: location, host : hostObject)
                    print("BlogEntry CREATED IN BLOG BY ID \n\n\n")
                    completion(blogEntry)
                    }
                }
            

        ).resume()
        
    }
    
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
                        
                        var projectInt = 0
                        guard let project = blogDict.value(forKey: "project") else { return }
                        if let projectString = project as? NSNumber{
                            projectInt = Int.init(truncating: projectString)
                            print(projectInt.description + "\n")
                        }
                        
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
                            image = UIImage(named: "blog-default")!
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
                        
                        guard let author = blogDict.value(forKey: "author") else { return }
                        var authorObject = Author()
                        if let authorDict = author as? NSDictionary{
                            guard let imageURL = authorDict.value(forKey: "image") else { return }
                            var image = UIImage(named: "profileBlack100")
                            if let img = imageURL as? String{
                                let imgURL = NSURL(string : Constants.url + img)
                                let data = NSData(contentsOf: (imgURL as URL?)!)
                                image = UIImage(data: data! as Data)!
                            }
                            
                            guard let name = authorDict.value(forKey: "name") else { return }
                            let nameString = name as! String
                            
                            authorObject = Author(image: image!, name: nameString)
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
                        
                        let blogEntry = BlogEntry(id: blogID!, title: blogTitle, text: blogText, created: blogCreated, updated: blogCreated, image: image, teaser: blogTeaser, range: blogRange,gallery: resultimages, projectInt: projectInt, author : authorObject, location: location, host: hostObject)
                        resultimages = []
                        blogList.append(blogEntry)
                    }
                }
                completion(blogList)

            }
            }).resume()
    }
}
