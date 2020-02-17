//
//  NewsViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 04.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{



    var imagesLoaded : Bool = false
    var postCount : Int = 5
    var count : Int = 0
    var newsList : [NewsEntry] = []
    var newsListProjectDetail: [NewsEntry] = []
    var switch_counter = 0
    var news_title = ""
    var news_description = ""
    var news_location = ""
    var news_date = ""
    var news_object : NewsEntry?
    var date = Date.init()
    @IBOutlet weak var tableView: UITableView!
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.switch_counter == 1){
            return self.newsListProjectDetail.count
        }
        return newsList.count
    }



     func tableView(_ tableView: UITableView,
                             cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.switch_counter != 1){

        // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier:"news_cell", for: indexPath)as! NewsTableViewCell
        // Zelle konfigurieren
        cell.news_image.image = newsList[indexPath.row].getImage
       // cell.formlabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
        // TODO If TEASER = NIL OR ""
        let date = newsList[indexPath.row].getCreationDate
        if(date.isToDate()){
            cell.news_date.text = "Heute"
        }else if(date.isYesterDate()){
            cell.news_date.text = "Gestern"
        }else{
            cell.news_date.text =  date.dateAndTimetoString()
        }
        cell.news_hostLbl.text = newsList[indexPath.row].getHost.getCity.uppercased()
        cell.news_description.text = newsList[indexPath.row].getTeaser.html2String
        cell.news_description.sizeToFit()
        cell.news_title.text = newsList[indexPath.row].getTitle.html2String
        cell.news_title.sizeToFit()
        cell.news_button_detail.tag = indexPath.row
         cell.triangle.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
        return cell
        }else{
            // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
             let cell = tableView.dequeueReusableCell(withIdentifier:"news_cell", for: indexPath)as! NewsTableViewCell
             // Zelle konfigurieren
           cell.news_image.image = newsListProjectDetail[indexPath.row].getImage
            // cell.formlabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
             // TODO If TEASER = NIL OR ""
             let date = newsListProjectDetail[indexPath.row].getCreationDate
             if(date.isToDate()){
                 cell.news_date.text = "Heute"
             }else if(date.isYesterDate()){
                 cell.news_date.text = "Gestern"
             }else{
                 cell.news_date.text =  date.dateAndTimetoString()
             }
             cell.news_hostLbl.text = newsListProjectDetail[indexPath.row].getHost.getCity.uppercased()
             cell.news_description.text = newsListProjectDetail[indexPath.row].getTeaser.html2String
             cell.news_description.sizeToFit()
             cell.news_title.text = newsListProjectDetail[indexPath.row].getTitle.html2String
             cell.news_title.sizeToFit()
             cell.news_button_detail.tag = indexPath.row
              cell.triangle.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
             return cell
            
        }
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.news_object = newsList[indexPath.row]
        self.performSegue(withIdentifier: "goToNewsDetail", sender: self)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.newsList.count - 1
        if ((indexPath.row) == lastElement) {
            DataService.loadNews(date: self.date) { (list) in
                for newsEntry in list{
                    self.newsList.append(newsEntry)
                }
                self.date = self.newsList.last!.getCreationDate
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }



override func viewDidLoad() {
    super.viewDidLoad()
    if(newsListProjectDetail.count > 0){
               self.switch_counter = 1
           }
           print("SWITCH COUNTER: "+self.switch_counter.description)
    
    DataService.loadNews(date: self.date) { (list) in
        self.newsList = list
        self.date = self.newsList.last!.getCreationDate
        
        DispatchQueue.main.async {
            self.tableView.reloadData()

        }

    }
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 600

}
    private func handleDate(date : String) -> Date{
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"
       dateFormatter.locale = Locale(identifier: "en_US_POSIX")
       return dateFormatter.date(from:date)!
   }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewsDetailViewController{
            let newsDetailViewController = segue.destination as? NewsDetailViewController
            newsDetailViewController?.news_object = self.news_object
        }
    }




}


/*

let regex = try! NSRegularExpression(pattern: "!\\[(.*?)\\]\\((.*?)\\\"")
let string = ""


*/
