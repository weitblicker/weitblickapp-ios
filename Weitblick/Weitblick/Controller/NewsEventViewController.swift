//
//  NewsViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

struct NewsDecodable : Codable{
    let id : String?
    let title : String?
    let text : String?
    let image : Int?
    let added : String?
    let updated : String?
    let range : String?
    
}



class NewsEventViewController: UIViewController {
    
    var newsList : [NewsEntry] = []
    
    
    @IBOutlet weak var NewsView: UIView!
    
    
    @IBOutlet weak var EventView: UIView!
    
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex==0){
            NewsView.alpha=1
            EventView.alpha=0
        } else{
            NewsView.alpha=0
            EventView.alpha=1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginWithData()
        NewsView.alpha=1
        EventView.alpha=0
    }
    
    private func handleDate(date : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        return dateFormatter.date(from:date)!
    }
    
    private func loginWithData(){

        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url: URL(string: "https://new.weitblicker.org/rest/news/?limit=3")!)
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
                    if let string = String(data: data, encoding: String.Encoding.utf8) {
                        let data = string.data(using: .utf8)!
                        //print(string)
                        do {
                            let f = try JSONDecoder().decode([NewsDecodable].self, from: data)
                            //print(f)
                            for news in f {
                                guard let id = news.id else { return }
                                guard let title = news.title else { return }
                                guard let text = news.text else { return }
                                guard let imageID = news.image else { return }
                                guard let created = news.added else { return }
                                guard let updated = news.updated else { return }
                                guard let range = news.range else { return }
                                let newsEntry = NewsEntry(id : Int.init(id)!, title : title, text : text, imageID : imageID, created : self.handleDate(date: created), updated : self.handleDate(date: updated), range : range);
                                print("Name")
                                print(newsEntry.getTitle)
                                print("Date")
                                print(newsEntry.getCreationDate)
                                
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
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
