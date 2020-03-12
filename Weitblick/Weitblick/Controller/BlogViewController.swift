//
//  BlogViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 14.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class BlogViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

    var blogList : [BlogEntry] = []
    var blogListProjectDetail : [BlogEntry] = []
    var switch_counter = 0
    var count = 0
    var postCount = 3
    var blog_object : BlogEntry?
    var image: UIImageView?
    var date : Date = Date()
    @IBOutlet weak var tableView: UITableView!

   //Größe der TableView abhängig von dargestellten Daten festlegen
   //Falls counter == 1 werden nur die Blog die zu einem Projekt gehören dargestellt
   //-->Diese Ansicht nur sichtbar wenn man von ProjektDetail auf "Mehr anzeigen" klickt
   //Falls nicht werden alle vorhandenen Blog aufgelistet
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.switch_counter == 1){
            return self.blogListProjectDetail.count
        }
        return blogList.count
    }

    //Blogzelle erstellen und Labels zuweisen
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier:"blog_cell", for: indexPath)as! BlogTableViewCell
        if(self.switch_counter == 1){
            //Blogzelle erstellen und ihren Labels die Daten zuweisen
            //Blogs die zu einem Projekt gehören darstellen
            cell.blog_city.text = self.blogListProjectDetail[indexPath.row].getHost.getCity.uppercased()
            cell.blog_city.font = UIFont(name: "OpenSans-Bold", size: 15)
            cell.blog_image.image = self.blogListProjectDetail[indexPath.row].getImage
            cell.blog_description.text = blogListProjectDetail[indexPath.row].getTeaser
            cell.blog_description.sizeToFit()
            cell.blog_date.text = blogListProjectDetail[indexPath.row].getCreationDate.dateAndTimetoString()
            cell.blog_title.text = blogListProjectDetail[indexPath.row].getTitle
            cell.blog_description.text = blogListProjectDetail[indexPath.row].getText
            cell.triangle.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
            cell.blog_title.sizeToFit()
        if(blogListProjectDetail[indexPath.row].getLocation.getAddress == ""){
            cell.blog_location_marker.alpha = 0
            cell.blog_country.text = "     "
            
        }else{
            cell.blog_country.text = blogListProjectDetail[indexPath.row].getLocation.getAddress
              }
        }else{
            //Alle Blogs darstellen
            //Blogzelle erstellen und ihren Labels die Daten zuweisen
            cell.blog_city.text = self.blogList[indexPath.row].getHost.getCity.uppercased()
            cell.blog_city.font = UIFont(name: "OpenSans-Bold", size: 15)
            cell.blog_image.image = self.blogList[indexPath.row].getImage
            cell.blog_description.text = blogList[indexPath.row].getTeaser
            cell.blog_description.sizeToFit()
            cell.blog_date.text = blogList[indexPath.row].getCreationDate.dateAndTimetoString()
            cell.blog_title.text = blogList[indexPath.row].getTitle
            cell.blog_description.text = blogList[indexPath.row].getText
            cell.triangle.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
            cell.blog_title.sizeToFit()
            if(blogList[indexPath.row].getLocation.getAddress == ""){
                cell.blog_location_marker.alpha = 0
                cell.blog_country.text = "     "
                
            }else{
                cell.blog_country.text = blogList[indexPath.row].getLocation.getAddress
                      
                  }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.blog_object = blogList[indexPath.row]
    self.performSegue(withIdentifier: "goToBlogDetail", sender: self)
    }

    //Blogdetail daten vom BlogService laden
    override func viewDidLoad() {
        super.viewDidLoad()
        if(blogListProjectDetail.count > 0){
            self.switch_counter = 1
        }
        BlogService.loadBlogs(date: self.date) { (list) in
            self.blogList = list
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    //Datum richtig anzeigen lassen
    private func handleDate(date : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from:date) ?? Date.init()
    }
    
   //Falls Blogzelle angeklickt wird BlogdetailController das Blogobjekt weiterleiten
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.destination is BlogDetailViewController
           {
            let blogDetailViewController = segue.destination as? BlogDetailViewController
            blogDetailViewController?.blog_object = self.blog_object
            blogDetailViewController?.image = self.image?.image


           }
       }




}
