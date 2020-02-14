//
//  DataService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 04.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class DataService{
    
    static func getNewsByID(id : Int, completion: @escaping (_ newsEntry : NewsEntry) -> ()){
        var hostPartnerList : [Int] = []
        var resultimages : [UIImage] = []
        let urlString = "https://weitblicker.org/rest/news/" + id.description
        let url = NSURL(string: urlString)
        let str = "surfer:hangloose"
        let dataB64 = Data(str.utf8).base64EncodedString();
        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + dataB64, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
            print("Successful GetNewsByID\n");
            if let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                if let newsDict = jsondata as? NSDictionary{

                    guard let id = newsDict.value(forKey: "id")  else { return }
                    let IDString = id as! String
                    let newsID = Int.init(IDString)

                    guard let title = newsDict.value(forKey: "title") else { return }
                    let newsTitle = title as! String

                    guard let text = newsDict.value(forKey: "text") else { return }
                    var newsText = text as! String
                    newsText = extractRegex(input: newsText, regex: DataService.matches(for: Constants.regexReplace, in: newsText))

                    guard let created = newsDict.value(forKey: "published") else { return } //from added to published
                    let createdString = created as! String
                    let substrings = createdString.split(separator: "Z")
                    let newsCreated = self.handleDateWithOutTimeZone(date: substrings.first!.description)
                    
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
                        resultimages.append(image)
                    }

                    guard let published = newsDict.value(forKey: "published") else { return }
                    let publishedString = published as! String
                    let newsUpdated = self.handleDateWithTimeZone(date: publishedString)
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
                    var projectInt = 0
                    guard let project = newsDict.value(forKey: "project") else { return }
                    if let projectString = project as? NSNumber{
                        projectInt = Int.init(truncating: projectString)
                    }
            
                    var hostObject = Host()
                    guard let host = newsDict.value(forKey: "host") else { return }
                    if let hostDict = host as? NSDictionary{
            
                        guard let hostID = hostDict.value(forKey: "id") else { return }
                        let hostIDString = hostID as! String
                        guard let hostName = hostDict.value(forKey : "name") else { return }
                
                        guard let city = hostDict.value(forKey: "city") else { return }
                        let cityString = city as! String
        
                        let hostNameString = hostName as! String
                        guard let hostPartners = hostDict.value(forKey : "partners") else { return }
                
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
            
                    guard let author = newsDict.value(forKey: "author") else { return }
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

                    let newsEntry = NewsEntry(id: newsID!, title: newsTitle, text: newsText, gallery: resultimages, created: newsCreated , updated: newsCreated, range: newsRange, image: image, teaser: newsTeaser, host: hostObject, projectInt : projectInt, author: authorObject)
                    completion(newsEntry)
                }
            }
        }).resume()
    }

    static func loadNews(date : Date,completion: @escaping (_ newsList : [NewsEntry]) -> ()){
        var newsList : [NewsEntry] = []
        var resultimages : [UIImage] = []
        var timestamp = date.dateAndTimetoStringISO()
        timestamp = timestamp + "Z"
        let url = NSURL(string: "https://weitblicker.org/rest/news/?end="+timestamp+"&limit=5")
        let str = "surfer:hangloose"
        let dataB64 = Data(str.utf8).base64EncodedString();
        var task = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        task.httpMethod = "GET"
        task.addValue("application/json", forHTTPHeaderField: "Content-Type")
        task.addValue("Basic " + dataB64, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: task, completionHandler: {(data,response,error) -> Void in
            if let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
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

                    guard let created = newsDict.value(forKey: "published") else { return } //from added to published
                    let createdString = created as! String
                    print(createdString)
                    let substrings = createdString.split(separator: "Z")
                    print(substrings.first!.description + "Z\n")
                    let newsCreated = self.handleDateWithOutTimeZone(date: substrings.first!.description)
//                    print(newsCreated.description + "\n")


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
                        resultimages.append(image)

                    }

                    guard let published = newsDict.value(forKey: "published") else { return }
                    let publishedString = published as! String
                    let newsUpdated = self.handleDateWithTimeZone(date: publishedString)
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
                    var projectInt = 0
                    guard let project = newsDict.value(forKey: "project") else { return }
                    if let projectString = project as? NSNumber{
                        projectInt = Int.init(truncating: projectString)
                        print(projectInt.description + "\n")
                    }
                    
                    
                    
                    var hostObject = Host()
                    guard let host = newsDict.value(forKey: "host") else { return }
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
                    
                    guard let author = newsDict.value(forKey: "author") else { return }
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

                    let newsEntry = NewsEntry(id: newsID!, title: newsTitle, text: newsText, gallery: resultimages, created: newsCreated , updated: newsCreated, range: newsRange, image: image, teaser: newsTeaser, host: hostObject, projectInt : projectInt, author: authorObject)
                    resultimages = []
                    newsList.append(newsEntry)
                }
            }
            completion(newsList)
                }}
        }).resume()

    }

    static func getProjectWithID (id: Int, completion: @escaping (_ project: Project) -> ()){
        var cellcount = 0;
        var resultimages : [UIImage] = []
        var projectReturn : Project?
        let string = Constants.projectURL + id.description + "/"
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
                                    resultimages.append(image)

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

                                var cycleObject : CycleEntry = CycleEntry()

                                guard let cycleArray = projectDict.value(forKey: "cycle")else { return }
                                if let cycleDict = cycleArray as? NSDictionary{
                                    cellcount = cellcount + 2;

                                    guard let euroSum = cycleDict.value(forKey: "euro_sum") else { return }
                                    let euroSumNumber = euroSum as! NSNumber
                                    let euroSumFloat = Float.init(truncating: euroSumNumber)

                                    guard let euro_goal = cycleDict.value(forKey: "euro_goal") else { return }
                                    let euroGoalNumber = euro_goal as! NSNumber
                                    let euroGoalFloat = Float.init(exactly: euroGoalNumber)

                                    var donationList : [Donation] = []
                                    guard let donations = cycleDict.value(forKey: "donations") else { return }
                                    if let donationArray = donations as? NSArray{
                                        var donationObject = Donation()
                                        for donation in donationArray{
                                            if let donationDict = donation as? NSDictionary{
                                                cellcount = cellcount + 2;
                                                guard let id = donationDict.value(forKey: "id") else { return }
                                                let idNumber = id as! String
                                                let idInt = Int.init(idNumber)

                                                var sponsorObject = Sponsor()
                                                guard let sponsor = donationDict.value(forKey: "partner") else { return }
                                                if let sponsorDict = sponsor as? NSDictionary{
                                                    guard let name = sponsorDict.value(forKey: "name") else { return }
                                                    let nameString = name as! String

                                                    guard let description = sponsorDict.value(forKey: "description") else { return }
                                                    let descriptionString = description as! String

                                                    guard let logo = sponsorDict.value(forKey: "logo") else { return }
                                                    let logoUrl = logo as! String
                                                    var logoImg : UIImage
                                                    if(logoUrl == ""){
                                                        let size = CGSize.init(width: 334, height: 176)
                                                        logoImg = UIImage(named: "Weitblick")!.crop(to: size)
                                                    }else{
                                                        let imgURL = NSURL(string : Constants.url + logoUrl)
                                                        let data = NSData(contentsOf: (imgURL as URL?)!)
                                                        logoImg = UIImage(data: data! as Data)!
                                                    }

                                                    guard let link = sponsorDict.value(forKey: "link") else { return }
                                                    let linkString = link as! String

                                                    sponsorObject = Sponsor(name: nameString, description: descriptionString, logo: logoImg, link: linkString)
                                                }

                                                guard let donationName = donationDict.value(forKey: "name") else { return }
                                                let donationNameString = donationName as! String

                                                guard let donationDescription = donationDict.value(forKey: "description") else { return }
                                                let donationDescriptionString = donationDescription as! String

                                                guard let donationGoalAmount = donationDict.value(forKey: "goal_amount") else { return }
                                                let donationGoalAmountNumber = donationGoalAmount as! NSNumber
                                                let donationGoalAmountFloat = Float.init(exactly: donationGoalAmountNumber)

                                                guard let donationRateEuroKM = donationDict.value(forKey : "rate_euro_km") else { return }
                                                let donationRateEuroKMNumber = donationRateEuroKM as! NSNumber
                                                let donationRateEuroKMFloat = Float.init(truncating: donationRateEuroKMNumber)
                                                print(donationRateEuroKMFloat)

                                                donationObject = Donation(id: idInt!, sponsor: sponsorObject, name: donationNameString, description: donationDescriptionString, goal_amount: donationGoalAmountFloat!, rate_euro_km: donationRateEuroKMFloat)
                                                donationList.append(donationObject)

                                            }
                                        }
                                    }
                                    guard let progress = cycleDict.value(forKey: "progress") else { return }
                                    let progressNSNumber = progress as! NSNumber
                                    let progressFloat = Float.init(truncating: progressNSNumber)

                                    guard let kmSum = cycleDict.value(forKey: "km_sum") else { return }
                                    //let kmSumNSNumber = kmSum as! NSNumber
                                    //let kmSumFloat = Float.init(exactly: kmSumNSNumber)
                                    let kmSumFloat : Float = 0.0

                                    guard let cyclists = cycleDict.value(forKey: "cyclists") else { return }
                                    let cyclistsNSNumber = cyclists as! NSNumber
                                    let cyclistsInt = Int.init(exactly: cyclistsNSNumber)

                                    cycleObject = CycleEntry(eurosum: euroSumFloat, euro_goal: euroGoalFloat!, donations: donationList, progress: progressFloat, km_sum: kmSumFloat, cyclists: cyclistsInt!)
                                }

                               guard let published = projectDict.value(forKey: "published") else { return }
                                let projectPublished = self.handleDateWithTimeZone(date: published as! String)

                                var newsIDArray : [Int] = []
                                guard let news = projectDict.value(forKey : "news") else { return }
                                if let newsArray = news as? NSArray{
                                    cellcount = cellcount + 1
                                    for newsID in newsArray{
                                        cellcount = cellcount + 1
                                        newsIDArray.append(newsID as! Int)
                                    }
                                }
                                var blogIDArray : [Int] = []
                                guard let blogs = projectDict.value(forKey: "blog") else { return }
                                if let blogArray = blogs as? NSArray{
                                    cellcount = cellcount + 1
                                    for blogID in blogArray{
                                        cellcount = cellcount + 1
                                        blogIDArray.append(blogID as! Int)
                                    }
                                }
                                
                                // TODO EVENTS WIE BEI BLOG UND NEWS
                                
            //                    private var name : String
            //                    private var description : String
            //                    private var date : Date
            //                    private var reached : Bool
                                var milestoneList : [Milestone] = []
                                guard let milestones = projectDict.value(forKey: "milestones") else { return }
                                if let milestoneArray = milestones as? NSArray{
                                    cellcount = cellcount + 1
                                    for m in milestoneArray{
                                        var milestoneObject = Milestone()
                                        if let milestoneDict = m as? NSDictionary{
                                            cellcount = cellcount + 1;
                                            guard let name = milestoneDict.value(forKey: "name") else { return }
                                            let nameString = name as! String
                                            
                                            guard let description = milestoneDict.value(forKey: "description") else { return }
                                            let descriptionString = description as! String
                                            
                                            guard let date = milestoneDict.value(forKey: "date") else { return }
                                            let dateString = date as! String
                                            let dateDate = handleDateSimple(date: dateString)
                                            guard let reached = milestoneDict.value(forKey: "reached") else { return }
                                            let reachedBool = reached as! Bool
                                            
                                            milestoneObject = Milestone(name: nameString, description: descriptionString, date: dateDate, reached: reachedBool)
                                            milestoneList.append(milestoneObject)
                                        }
                                    }
                                }
                                var partnerList : [Partner] = []
                                guard let partners = projectDict.value(forKey: "partners") else { return }
                                if let partnerArray = partners as? NSArray{
                                    cellcount = cellcount + 1
                                    for partnerEntry in partnerArray{
                                        cellcount = cellcount + 1
                                        var partnerObject = Partner()
                                        if let partnerDict = partnerEntry as? NSDictionary{
                                            guard let name = partnerDict.value(forKey: "name") else { return }
                                            let nameString = name as! String
                                            
                                            guard let description = partnerDict.value(forKey: "description") else { return }
                                            let descriptionString = description as! String
                                            
                                            guard let logo = partnerDict.value(forKey : "logo") else { return }
                                            var logoImg = UIImage(named: "Weitblick")!
                                            if let urlString = logo as? String{
                                                 let imgURL = NSURL(string : Constants.url + urlString)
                                                let data = NSData(contentsOf: (imgURL as URL?)!)
                                                logoImg = UIImage(data: data! as Data)!
                                            }
                                            partnerObject = Partner(name: nameString, description: descriptionString, logo: logoImg)
                                            partnerList.append(partnerObject)
                                        }
                                    }
                                }


                                var resultHosts : [Host] = []
                                guard let hosts = projectDict.value(forKey: "hosts") else { return }
                                if let hostArray = hosts as? NSArray{
                                    for host in hostArray{
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
                                            let hostObject = Host(id: hostIDString, name: hostName as! String, partners: hostPartnerList, bankAccount: hostbankAcc, location: location, city: cityString)
                                            resultHosts.append(hostObject)
                                        }
                                    }
                                }


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
                                
                                // TODO Zelle mit donation account, donation description, donation goal, donbnation current +1Zelle wenn vorhanden

                                let project = Project(id: projectID!, published: projectPublished, name: projectTitle, image: image, gallery: resultimages, hosts: resultHosts, description: projectDescription, location: location , partnerID: [], cycleObject: cycleObject, news: newsIDArray, blog: blogIDArray, milestones: milestoneList, partners: partnerList, cellCount: cellcount)
                                resultimages = []
                                cellcount = 0;
                                print("Project with ID successfully fetched!\n")
                                completion(project)
                            }
        
        }
        request.resume()
    
    }



static func loadProjects(date : Date,completion: @escaping (_ projectList : [Project]) -> ()){
        var cellcount = 0;
        var projectList : [Project] = []
        var resultimages : [UIImage] = []
        // /rest/news?start=2019-10-01&end=2020-01-01&limit=30
        //let url = NSURL(string: Constants.restURL + "?start=1970-01-01&end="+date.dateAndTimetoStringUS()+"&limit=3")
        let timestamp = date.dateAndTimetoStringUS()
        let url = NSURL(string: "https://weitblicker.org/rest/projects/")

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
                        resultimages.append(image)

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

                    var cycleObject : CycleEntry = CycleEntry()

                    guard let cycleArray = projectDict.value(forKey: "cycle")else { return }
                    if let cycleDict = cycleArray as? NSDictionary{
                        cellcount = cellcount + 2;

                        guard let euroSum = cycleDict.value(forKey: "euro_sum") else { return }
                        let euroSumNumber = euroSum as! NSNumber
                        let euroSumFloat = Float.init(truncating: euroSumNumber)

                        guard let euro_goal = cycleDict.value(forKey: "euro_goal") else { return }
                        let euroGoalNumber = euro_goal as! NSNumber
                        let euroGoalFloat = Float.init(exactly: euroGoalNumber)

                        var donationList : [Donation] = []
                        guard let donations = cycleDict.value(forKey: "donations") else { return }
                        if let donationArray = donations as? NSArray{
                            var donationObject = Donation()
                            for donation in donationArray{
                                if let donationDict = donation as? NSDictionary{
                                    cellcount = cellcount + 2;
                                    guard let id = donationDict.value(forKey: "id") else { return }
                                    let idNumber = id as! String
                                    let idInt = Int.init(idNumber)

                                    var sponsorObject = Sponsor()
                                    guard let sponsor = donationDict.value(forKey: "partner") else { return }
                                    if let sponsorDict = sponsor as? NSDictionary{
                                        guard let name = sponsorDict.value(forKey: "name") else { return }
                                        let nameString = name as! String

                                        guard let description = sponsorDict.value(forKey: "description") else { return }
                                        let descriptionString = description as! String

                                        guard let logo = sponsorDict.value(forKey: "logo") else { return }
                                        let logoUrl = logo as! String
                                        var logoImg : UIImage
                                        if(logoUrl == ""){
                                            let size = CGSize.init(width: 334, height: 176)
                                            logoImg = UIImage(named: "Weitblick")!.crop(to: size)
                                        }else{
                                            let imgURL = NSURL(string : Constants.url + logoUrl)
                                            let data = NSData(contentsOf: (imgURL as URL?)!)
                                            logoImg = UIImage(data: data! as Data)!
                                        }

                                        guard let link = sponsorDict.value(forKey: "link") else { return }
                                        let linkString = link as! String

                                        sponsorObject = Sponsor(name: nameString, description: descriptionString, logo: logoImg, link: linkString)
                                    }

                                    guard let donationName = donationDict.value(forKey: "name") else { return }
                                    let donationNameString = donationName as! String

                                    guard let donationDescription = donationDict.value(forKey: "description") else { return }
                                    let donationDescriptionString = donationDescription as! String

                                    guard let donationGoalAmount = donationDict.value(forKey: "goal_amount") else { return }
                                    let donationGoalAmountNumber = donationGoalAmount as! NSNumber
                                    let donationGoalAmountFloat = Float.init(exactly: donationGoalAmountNumber)

                                    guard let donationRateEuroKM = donationDict.value(forKey : "rate_euro_km") else { return }
                                    let donationRateEuroKMNumber = donationRateEuroKM as! NSNumber
                                    let donationRateEuroKMFloat = Float.init(truncating: donationRateEuroKMNumber)
                                    print(donationRateEuroKMFloat)

                                    donationObject = Donation(id: idInt!, sponsor: sponsorObject, name: donationNameString, description: donationDescriptionString, goal_amount: donationGoalAmountFloat!, rate_euro_km: donationRateEuroKMFloat)
                                    donationList.append(donationObject)

                                }
                            }
                        }
                        guard let progress = cycleDict.value(forKey: "progress") else { return }
                        let progressNSNumber = progress as! NSNumber
                        let progressFloat = Float.init(truncating: progressNSNumber)

                        guard let kmSum = cycleDict.value(forKey: "km_sum") else { return }
                        //let kmSumNSNumber = kmSum as! NSNumber
                        //let kmSumFloat = Float.init(exactly: kmSumNSNumber)
                        let kmSumFloat : Float = 0.0

                        guard let cyclists = cycleDict.value(forKey: "cyclists") else { return }
                        let cyclistsNSNumber = cyclists as! NSNumber
                        let cyclistsInt = Int.init(exactly: cyclistsNSNumber)

                        cycleObject = CycleEntry(eurosum: euroSumFloat, euro_goal: euroGoalFloat!, donations: donationList, progress: progressFloat, km_sum: kmSumFloat, cyclists: cyclistsInt!)
                    }

                   guard let published = projectDict.value(forKey: "published") else { return }
                    let projectPublished = self.handleDateWithTimeZone(date: published as! String)

                    var newsIDArray : [Int] = []
                    guard let news = projectDict.value(forKey : "news") else { return }
                    if let newsArray = news as? NSArray{
                        cellcount = cellcount + 1
                        for newsID in newsArray{
                            cellcount = cellcount + 1
                            newsIDArray.append(newsID as! Int)
                        }
                    }
                    var blogIDArray : [Int] = []
                    guard let blogs = projectDict.value(forKey: "blog") else { return }
                    if let blogArray = blogs as? NSArray{
                        cellcount = cellcount + 1
                        for blogID in blogArray{
                            cellcount = cellcount + 1
                            blogIDArray.append(blogID as! Int)
                        }
                    }
                    
                    // TODO EVENTS WIE BEI BLOG UND NEWS
                    
//                    private var name : String
//                    private var description : String
//                    private var date : Date
//                    private var reached : Bool
                    var milestoneList : [Milestone] = []
                    guard let milestones = projectDict.value(forKey: "milestones") else { return }
                    if let milestoneArray = milestones as? NSArray{
                        cellcount = cellcount + 1
                        for m in milestoneArray{
                            var milestoneObject = Milestone()
                            if let milestoneDict = m as? NSDictionary{
                                cellcount = cellcount + 1;
                                guard let name = milestoneDict.value(forKey: "name") else { return }
                                let nameString = name as! String
                                
                                guard let description = milestoneDict.value(forKey: "description") else { return }
                                let descriptionString = description as! String
                                
                                guard let date = milestoneDict.value(forKey: "date") else { return }
                                let dateString = date as! String
                                let dateDate = handleDateSimple(date: dateString)
                                guard let reached = milestoneDict.value(forKey: "reached") else { return }
                                let reachedBool = reached as! Bool
                                
                                milestoneObject = Milestone(name: nameString, description: descriptionString, date: dateDate, reached: reachedBool)
                                milestoneList.append(milestoneObject)
                            }
                        }
                    }
                    var partnerList : [Partner] = []
                    guard let partners = projectDict.value(forKey: "partners") else { return }
                    if let partnerArray = partners as? NSArray{
                        cellcount = cellcount + 1
                        for partnerEntry in partnerArray{
                            cellcount = cellcount + 1
                            var partnerObject = Partner()
                            if let partnerDict = partnerEntry as? NSDictionary{
                                guard let name = partnerDict.value(forKey: "name") else { return }
                                let nameString = name as! String
                                
                                guard let description = partnerDict.value(forKey: "description") else { return }
                                let descriptionString = description as! String
                                
                                guard let logo = partnerDict.value(forKey : "logo") else { return }
                                var logoImg = UIImage(named: "Weitblick")!
                                if let urlString = logo as? String{
                                     let imgURL = NSURL(string : Constants.url + urlString)
                                    let data = NSData(contentsOf: (imgURL as URL?)!)
                                    logoImg = UIImage(data: data! as Data)!
                                }
                                partnerObject = Partner(name: nameString, description: descriptionString, logo: logoImg)
                                partnerList.append(partnerObject)
                            }
                        }
                    }


                    var resultHosts : [Host] = []
                    guard let hosts = projectDict.value(forKey: "hosts") else { return }
                    if let hostArray = hosts as? NSArray{
                        for host in hostArray{
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
                                let hostObject = Host(id: hostIDString, name: hostName as! String, partners: hostPartnerList, bankAccount: hostbankAcc, location: location, city: cityString)
                                resultHosts.append(hostObject)
                            }
                        }
                    }


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
                    
                    // TODO Zelle mit donation account, donation description, donation goal, donbnation current +1Zelle wenn vorhanden

                    let project = Project(id: projectID!, published: projectPublished, name: projectTitle, image: image, gallery: resultimages, hosts: resultHosts, description: projectDescription, location: location , partnerID: [], cycleObject: cycleObject, news: newsIDArray, blog: blogIDArray, milestones: milestoneList, partners: partnerList, cellCount: cellcount)
                    projectList.append(project)
                    resultimages = []
                    cellcount = 0;
                }
            }
            completion(projectList)
            }
        }).resume()
    }
    
    

    


    static func handleDate(date : String) -> Date{
        let dateFormatter = DateFormatter()
        //2020-01-23T11:20:07Z+0000
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from:date)!
    }
    
    static func handleDateSimple(date : String) -> Date{
        let dateFormatter = DateFormatter()
        //2020-01-23T11:20:07Z+0000
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from:date)!
    }

    static func handleDateWithOutTimeZone(date : String) -> Date{
        let dateFormatter = DateFormatter()
        //2020-01-23T11:20:07Z+0000
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from:date)!
    }



    static func handleDateWithTimeZone(date : String) -> Date{
        let dateFormatter = DateFormatter()
        //2020-01-23T11:20:07Z+0000
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ+0000"
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
