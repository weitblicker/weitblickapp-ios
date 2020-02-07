//
//  NewsDetailViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import MapKit
import MarkdownKit

class NewsDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate {
  
    
    
//NEWS Variablen
   
    @IBOutlet weak var news_detail_loaction: UILabel!
    @IBOutlet weak var news_detail_date: UILabel!
    @IBOutlet weak var news_detail_title: UILabel!
    @IBOutlet weak var news_detail_description: UILabel!
     @IBOutlet var photoSliderView: PhotoSliderView!
    @IBOutlet weak var news_detail_image: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    var id = -1
    var project : Project?
    
   
    //EVENT Variablen
  
    var news_object : NewsEntry?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewsDetail()
        self.tableView.delegate = self
        self.tableView.dataSource = self
      
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          1
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell =  tableView.dequeueReusableCell(withIdentifier:"newsproject_cell", for: indexPath)as! NewsDetailProjectCell
          
          cell.project_image!.image = UIImage (named: "Weitblick")
          cell.project_title.text = "Project Title"
          cell.project_partner.text = "Partner"
          cell.project_location.text = "Deutschland"

          
        /*  if(self.projectList[indexPath.row].getCycleObject.getDonations.isEmpty){
                     cell.project_ride_button.alpha = 0
                 }else{
                     cell.project_button_bike.alpha = 1*/
          return cell
      }
    override func viewWillAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        let imageView = UIImageView(frame : CGRect(x : 0 , y : 0, width : 40 , height : 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named : "Weitblick")
        imageView.image = image
        navigationItem.titleView = imageView
      

    }
    
    
    func loadNewsDetail(){
        
        let markdownParser = MarkdownParser()
        news_detail_description.attributedText = markdownParser.parse(news_object!.getText)
        news_detail_description.sizeToFit()
        news_detail_date.text = news_object?.getCreationDate.dateAndTimetoString()
        news_detail_title.text = news_object?.getTitle
        news_detail_loaction.text = "Osnabrück"
        photoSliderView.configure(with: (self.news_object?.getGallery)!)
        
        
    }
   

}
