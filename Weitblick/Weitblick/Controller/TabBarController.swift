//
//  TabBarController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class TabBarController: SwipeableTabBarController {
    
    var eventCollection : EventCollection = EventCollection()
    var newsCollection : NewsCollection = NewsCollection()
    var blogCollection : BlogCollection = BlogCollection()
    var projectCollection : ProjectCollection = ProjectCollection()
    var eventsLoaded : Bool = false
    var newsLoaded : Bool = false
    var blogsLoaded : Bool = false
    var projectsLoaded : Bool = false
    var selector : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.sideBySide
    }
    override func viewWillAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        let imageView = UIImageView(frame : CGRect(x : 0 , y : 0, width : 40 , height : 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named : "Weitblick")
        imageView.image = image
        navigationItem.titleView = imageView
        
    
        
        //LOADING DATA
       // fetchData(string: "news")
      
    }
    
    public func loadData(){
      fetchData(string: "news")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func handleDate(date : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        return dateFormatter.date(from:date)!
    }
    
    private func getNews(f : [NewsDecodable]){
        print("Loading news..")
        for news in f {
            guard let id = news.id else { return }
            guard let title = news.title else { return }
            guard let text = news.text else { return }
            guard let gallery = news.gallery else { return }
            guard let created = news.added else { return }
            guard let updated = news.updated else { return }
            guard let range = news.range else { return }
            let newsEntry = NewsEntry(id : Int.init(id)!, title : title, text : text, gallery : gallery, created : self.handleDate(date: created), updated : self.handleDate(date: updated), range : range);
            self.newsCollection.addNewsEntry(newsEntry: newsEntry)
            //print(newsEntry.getTitle)
        }
        print("News loaded.")
        newsLoaded = true
    }
    
    // TODO
    
//    private func getEvents(f : [EventDecodable]){
//        print("Loading events..")
//        for news in f {
//            guard let id = news.id else { return }
//            guard let title = news.title else { return }
//            guard let text = news.text else { return }
//            guard let gallery = news.gallery else { return }
//            guard let created = news.added else { return }
//            guard let updated = news.updated else { return }
//            guard let range = news.range else { return }
//            let newsEntry = NewsEntry(id : Int.init(id)!, title : title, text : text, gallery : gallery, created : self.handleDate(date: created), updated : self.handleDate(date: updated), range : range);
//            self.newsCollection.addNewsEntry(newsEntry: newsEntry)
//        }
//        print("News loaded.")
//    }

    
    private func fetchData(string : String){
        
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url: URL(string: "https://new.weitblicker.org/rest/\(string)/?limit=3")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
            do {
                let options = JSONSerialization.WritingOptions.prettyPrinted
                do {
                    let data = try JSONSerialization.data(withJSONObject: responseJSON as Any, options: options)
                    if let s = String(data: data, encoding: String.Encoding.utf8) {
                        let data = s.data(using: .utf8)!
                        do {
                            switch(string){
                            case "news":
                                var f = try JSONDecoder().decode([NewsDecodable].self, from: data)
                                self.getNews(f: f)
                            case "events":
                                var f = try JSONDecoder().decode([EventDecodable].self, from: data)
                            case "blog":
                                var f = try JSONDecoder().decode([BlogDecodable].self, from: data)
                            case "projects":
                                var f = try JSONDecoder().decode([ProjectDecodable].self, from: data)
                            default:
                                print("STRING_FORMAT_ERROR")
                            }
                            
                        } catch {
                            print(error)
                        }
                    }
                } catch {
                  print(error)
                }
            }
        })
        task.resume()
    }
}
