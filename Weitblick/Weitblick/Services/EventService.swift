//
//  EventService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 27.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class EventService{
    
    static func getEventByID(id : Int, completion : @escaping (_ eventEntry : Event) -> ()){
        
        var resultimages : [UIImage] = []
        let urlString = "https://weitblicker.org/rest/events/" + id.description
        let url = NSURL(string: urlString)// + timestamp.description + "&limit=3")
        let str = "surfer:hangloose"
        let dataB64 = Data(str.utf8).base64EncodedString();
        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + dataB64, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
            let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let eventDict = jsondata as? NSDictionary{
                
                guard let id = eventDict.value(forKey: "id")  else { return }
                let IDString = id as! String
                let eventID = Int.init(IDString)
                
                guard let title = eventDict.value(forKey: "title") else { return }
                let eventTitle = title as! String
                
                var hostObject = Host()
                guard let host = eventDict.value(forKey: "host") else { return }
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
                
                guard let locationJSON = eventDict.value(forKey: "location") else { return }
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
                
                guard let imageURLJSON = eventDict.value(forKey : "image") else { return }
                var imageURL = ""
                if let mainImageDict = imageURLJSON as? NSDictionary{
                    guard let imgURL = mainImageDict.value(forKey: "url") else { return }
                    imageURL = imgURL as! String
                }
                var image : UIImage
                if(imageURL == ""){
                    let size = CGSize.init(width: 334, height: 176)
                    image = UIImage(named: "event-default")!.crop(to: size)
                }else{
                    let imgURL = NSURL(string : Constants.url + imageURL)
                    let data = NSData(contentsOf: (imgURL as URL?)!)
                    image = UIImage(data: data! as Data)!
                }
                
                guard let gallery = eventDict.value(forKey: "photos") else { return }
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
                
                guard let startDateString = eventDict.value(forKey: "start") else { return }
                let startStringDate = startDateString as! String
                print(startStringDate)
                let start = DataService.handleDate(date: startStringDate)
                
                guard let endDateString = eventDict.value(forKey: "end") else { return }
                let endStringDate = endDateString as! String
                let end = DataService.handleDate(date: endStringDate)
                
                guard let description = eventDict.value(forKey: "description") else { return }
                let eventDescription = description as! String
                
                let event = Event(id: eventID!, title: eventTitle, description: eventDescription, image: image, host: hostObject, location: location, gallery: resultimages, dateStart: start, dateEnd: end)
                completion(event)
            }
        }).resume()
    }
    
    static func loadEvents(date : Date,completion: @escaping (_ eventList : [Event]) -> ()){
        var eventList : [Event] = []
        var resultimages : [UIImage] = []
        
        let timestamp = date.dateAndTimetoStringISO()
        let url = NSURL(string: "https://weitblicker.org/rest/events/")// + timestamp.description + "&limit=3")
        let str = "surfer:hangloose"
        let dataB64 = Data(str.utf8).base64EncodedString();
        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + dataB64, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
            let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let eventArray = jsondata as? NSArray{
                    
                for events in eventArray{
                    if let eventDict = events as? NSDictionary{
                        
                        guard let id = eventDict.value(forKey: "id")  else { return }
                        let IDString = id as! String
                        let eventID = Int.init(IDString)
                        
                        guard let title = eventDict.value(forKey: "title") else { return }
                        let eventTitle = title as! String
                        
                        var hostObject = Host()
                        guard let host = eventDict.value(forKey: "host") else { return }
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
                        
                        guard let locationJSON = eventDict.value(forKey: "location") else { return }
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
                        
                        guard let imageURLJSON = eventDict.value(forKey : "image") else { return }
                        var imageURL = ""
                        if let mainImageDict = imageURLJSON as? NSDictionary{
                            guard let imgURL = mainImageDict.value(forKey: "url") else { return }
                            imageURL = imgURL as! String
                        }
                        var image : UIImage
                        if(imageURL == ""){
                            let size = CGSize.init(width: 334, height: 176)
                            image = UIImage(named: "event-default")!.crop(to: size)
                        }else{
                            let imgURL = NSURL(string : Constants.url + imageURL)
                            let data = NSData(contentsOf: (imgURL as URL?)!)
                            image = UIImage(data: data! as Data)!
                        }
                        
                        guard let gallery = eventDict.value(forKey: "photos") else { return }
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
                        
                        guard let startDateString = eventDict.value(forKey: "start") else { return }
                        let startStringDate = startDateString as! String
                        print(startStringDate)
                        let start = DataService.handleDate(date: startStringDate)
                        
                        guard let endDateString = eventDict.value(forKey: "end") else { return }
                        let endStringDate = endDateString as! String
                        let end = DataService.handleDate(date: endStringDate)
                        
                        guard let description = eventDict.value(forKey: "description") else { return }
                        let eventDescription = description as! String
                        
                        let event = Event(id: eventID!, title: eventTitle, description: eventDescription, image: image, host: hostObject, location: location, gallery: resultimages, dateStart: start, dateEnd: end)
                        eventList.append(event)
                        resultimages = [] 
                    }
                }
                completion(eventList)
            }
        }).resume()
    }
}
