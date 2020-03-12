//
//  NewsViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 04.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    //Error Benachrichtigungen ausgeben
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "We've encountered some network issues. Please try again later .."
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

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
    //News Tabelle anlegen und Größe bestimmen
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //Größe anhanging von Daten die dargestellt werden
    //Entweder alle News die es gibt, ob die zugehörigen News zu einem Projekt
    //-->Diese Ansicht nur sichtbar wenn man von ProjektDetail auf "Mehr anzeigen" klickt
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.switch_counter == 1){
            return self.newsListProjectDetail.count
        }
        return newsList.count
    }



     func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Alle News anzeigen lassen
        //Newszelle erstellen und ihren Labels die Daten zuweisen
        if(self.switch_counter != 1){
        // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier:"news_cell", for: indexPath)as! NewsTableViewCell
        // Zelle konfigurieren
        cell.news_image.image = newsList[indexPath.row].getImage
        let date = newsList[indexPath.row].getCreationDate
        if(date.isToDate()){
            cell.news_date.text = "Heute"
        }else if(date.isYesterDate()){
            cell.news_date.text = "Gestern"
        }else{
            cell.news_date.text =  date.dateAndTimetoString()
        }
        cell.news_hostLbl.text = newsList[indexPath.row].getHost.getCity.uppercased()
        cell.news_hostLbl.font = UIFont(name: "OpenSans-Bold", size: 15)
        cell.news_description.text = newsList[indexPath.row].getTeaser.html2String
        cell.news_description.sizeToFit()
        cell.news_title.text = newsList[indexPath.row].getTitle.html2String
        cell.news_title.sizeToFit()
        cell.news_button_detail.tag = indexPath.row
         cell.triangle.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
        return cell
        //News zugehörig zu einem Projekt darstellen
        //Newszelle erstellen und ihren Labels die Daten zuweisen
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

    //Falls Zelle angeklickt wird zu NewsDetailView wechseln
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.news_object = newsList[indexPath.row]
        self.performSegue(withIdentifier: "goToNewsDetail", sender: self)
    }

    //Newsdaten vom DataService laden
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


    //Datem vom Service laden
    //TableView erstellen
    override func viewDidLoad() {
        super.viewDidLoad()
        if(newsListProjectDetail.count > 0){
                   self.switch_counter = 1
               }
        
        DataService.loadNews(date: self.date) { (list) in
            if(list.isEmpty){
                return
            }
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
    //Datum richtig anzeigen lassen
    private func handleDate(date : String) -> Date{
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"
       dateFormatter.locale = Locale(identifier: "en_US_POSIX")
       return dateFormatter.date(from:date)!
   }
    //Falls Newszelle ausgewählt wird dem NewsDetailViewController das News Objekt übergeben damit dieser das richtig anzeigen lassen kann
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewsDetailViewController{
            let newsDetailViewController = segue.destination as? NewsDetailViewController
            newsDetailViewController?.news_object = self.news_object
        }
    }




}

