//
//  FAQService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 11.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class FAQService{
    
    static func loadContact(completion: @escaping (_ contactObject : ContactObject?, _ error : NSError?) -> ()){
    
        let url = NSURL(string : Constants.contactURL)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request, completionHandler: {(data,response,error) -> Void in
            if let data = data{
                let jsondata = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                           if let contactDict = jsondata as? NSDictionary{
                               
                               guard let title = contactDict.value(forKey: "title")  else { return }
                               let titleString = title as! String
                               
                               var image : UIImage?
                               guard let imageJSON = contactDict.value(forKey : "image") else { return }
                               if let imageString = imageJSON as? String{
                                   if(imageString == ""){
                                       let size = CGSize.init(width: 334, height: 176)
                                       image = UIImage(named: "Weitblick")!.crop(to: size)
                                   }else{
                                       let imgURL = NSURL(string : Constants.url + imageString)
                                       let data = NSData(contentsOf: (imgURL as URL?)!)
                                       image = UIImage(data: data! as Data)!
                                   }
                               }
                               
                               guard let text = contactDict.value(forKey: "text")  else { return }
                               let textString = text as! String
                               
                               let contactObject = ContactObject(title: titleString, image: image!, text: textString)
                               completion(contactObject,nil)
            }else{
                let error = error as NSError?
                completion(nil, error)
            }
            }
        }).resume()
    }
    
    static func loadAGBS(completion: @escaping (_ agbObject : AGBObject?, _ err : NSError?) -> ()){
//        private var title: String
//        private var image : UIImage
//        private var text : String
//
        let url = NSURL(string : Constants.agbURL)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request, completionHandler: {(data,response,error) -> Void in
            if let data = data{
                let jsondata = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let agbDict = jsondata as? NSDictionary{
                    guard let title = agbDict.value(forKey: "title")  else { return }
                    let titleString = title as! String
                    
                    var image : UIImage?
                    guard let imageJSON = agbDict.value(forKey : "image") else { return }
                    if let imageString = imageJSON as? String{
                        if(imageString == ""){
                            let size = CGSize.init(width: 334, height: 176)
                            image = UIImage(named: "Weitblick")!.crop(to: size)
                        }else{
                            let imgURL = NSURL(string : Constants.url + imageString)
                            let data = NSData(contentsOf: (imgURL as URL?)!)
                             image = UIImage(data: data! as Data)!
                        }
                    }
                    
                    guard let text = agbDict.value(forKey: "text")  else { return }
                    let textString = text as! String
                    
                    let agbObject = AGBObject(title: titleString, image: image!, text: textString)
                    completion(agbObject,nil)
                }
            }else{
                let nsurlerror = error as NSError?
                completion(nil,nsurlerror)
            }
            
            
        }).resume()
        
        
    }
    
    static func loadCredits(completion: @escaping (_ creditObject : Creditobject?, _ error : NSError?) -> ()){
        
        let url = NSURL(string : Constants.creditURL)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request, completionHandler: {(data,response,error) -> Void in
            if let data = data{
                let jsondata = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let creditDict = jsondata as? NSDictionary{
                    
                    guard let id = creditDict.value(forKey: "id")  else { return }
                    let idNumber = id as! String
                    let idInt = Int.init(idNumber)
                    
                    guard let name = creditDict.value(forKey: "name")  else { return }
                    let nameString = name as! String
                    
                    guard let description = creditDict.value(forKey: "description")  else { return }
                    let descriptionString = description as! String
                    
                    guard let imageURLJSON = creditDict.value(forKey : "image") else { return }
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
                    var memberList : [Member] = []
                    guard let members = creditDict.value(forKey: "member") else { return }
                    if let membersArray = members as? NSArray{
                        for memberItem in membersArray{
                            if let memberDict = memberItem as? NSDictionary{
                                
                                guard let name = memberDict.value(forKey: "name") else { return }
                                let nameString = name as! String
                                
                                guard let role = memberDict.value(forKey: "role") else { return }
                                let roleString = role as! String
                                
                                var image : UIImage = UIImage.init(named: "profileBlack100")!
                                guard let imageJSON = memberDict.value(forKey: "image") else { return }
                                if let imageString = imageJSON as? String{
                                    if(imageString == ""){
                                        let size = CGSize.init(width: 334, height: 176)
                                        image = UIImage(named: "Weitblick")!.crop(to: size)
                                    }else{
                                        let imgURL = NSURL(string : Constants.url + imageString)
                                        let data = NSData(contentsOf: (imgURL as URL?)!)
                                        image = UIImage(data: data! as Data)!
                                    }
                                }
                                
                                
                                guard let email = memberDict.value(forKey: "email") else { return }
                                let emailString = email as! String
                                
                                guard let text = memberDict.value(forKey: "text") else { return }
                                let textString = text as! String
                                
                                let member = Member(name: nameString, role: roleString, image: image, email: emailString, text: textString)
                                memberList.append(member)
                            }
                        }
                    }
                    let creditObject = Creditobject(id: idInt!, name: nameString, description: descriptionString, image: image, members: memberList)
                    completion(creditObject,nil)
            }else{
                let nsurlError = error as NSError?
                completion(nil,nsurlError)
            }
            }
        }).resume()
    }
    
    static func loadFAQ( completion: @escaping (_ questions : [FAQEntry] ) -> ()){
        print("In FAQService")
        var resultArray : [FAQEntry] = []
        let string = Constants.restURL + "/faq/"
        print(string)
        let url = NSURL(string: string)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request, completionHandler: {(data,response,error) -> Void in
            if let data = data{
                let jsondata = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                         if let faqArray = jsondata as? NSArray{

                             for faqSection in faqArray{
                
                                 if let faqDict = faqSection as? NSDictionary{
                                     guard let title = faqDict.value(forKey: "title")  else { return }
                                     let titleString = title as! String
                                     guard let faqs = faqDict.value(forKey: "faqs")  else { return }
                                     if let questions = faqs as? NSArray{
                                         for question in questions{
                                             if let questionDict = question as? NSDictionary{
                                                 guard let questionText = questionDict.value(forKey : "question") else { return }
                                                 let questionString = questionText as! String
                                                 guard let answerText = questionDict.value(forKey : "answer")  else { return }
                                                 let answerString = answerText as! String
                                                 let faqQuestion = FAQEntry(title: titleString, question: questionString, answer: answerString)
                                                 
                                                 resultArray.append(faqQuestion)                                }
                                         }
                                     }
                                 }
                             }
                             DispatchQueue.main.async {
                                 completion(resultArray)
                             }
            }else{
                completion([])
            }
            }
        }).resume()
    }
}
