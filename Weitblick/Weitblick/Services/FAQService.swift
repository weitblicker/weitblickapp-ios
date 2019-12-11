//
//  FAQService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 11.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class FAQService{
    
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
        print("<")
        URLSession.shared.dataTask(with: request, completionHandler: {(data,response,error) -> Void in
            
            let jsondata = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
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
            }
        }).resume()
    }
}
