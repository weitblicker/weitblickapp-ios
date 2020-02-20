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
    @IBOutlet weak var news_detail_author: UILabel!
    @IBOutlet weak var news_detail_author_image: UIImageView!
    
    @IBOutlet weak var project_label: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var id = -1
    var project : Project?
    
    
    @IBOutlet weak var orangeLabel: UILabel!
    
    //EVENT Variablen
  
    var news_object : NewsEntry?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadNewsDetail()
        self.navigationController!.navigationBar.topItem!.title = "Zurück"
        
       
        
      
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          1
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell =  tableView.dequeueReusableCell(withIdentifier:"newsproject_cell", for: indexPath)as! NewsDetailProjectCell
        cell.project_title.text = self.project?.getName
        cell.project_location.text = self.project?.getLocation.getAddress
        cell.project_partner.text = self.project?.getHosts.first?.getCity.uppercased()
        cell.project_image.image = self.project?.getImage
        
          return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToProjectDetail", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProjectDetailViewController{
            let projectDetailViewController = segue.destination as? ProjectDetailViewController
            projectDetailViewController?.project_object = self.project
        }
    }
    
    
    func loadNewsDetail(){
        
        let markdownParser = MarkdownParser()
        news_detail_description.attributedText = markdownParser.parse(news_object!.getText)
        news_detail_description.sizeToFit()
        news_detail_date.text = news_object?.getCreationDate.dateAndTimetoString()
        news_detail_title.text = news_object?.getTitle
        news_detail_loaction.text = news_object?.getHost.getCity.uppercased()
        news_detail_loaction.font = UIFont(name: "OpenSans-Bold", size: 15)
        news_detail_author.text = news_object?.getAuthor.getName
        news_detail_author_image.image = news_object?.getAuthor.getImage
        photoSliderView.configure(with: (self.news_object?.getGallery)!)
        if(news_object!.getProjectInt != 0){
            loadProject()
        }else{
            self.tableView.alpha = 0
            self.project_label.text = ""
            orangeLabel.alpha = 0
        }
    }
    
    public func loadProject(){
        self.id = news_object!.getProjectInt
        DataService.getProjectWithID(id: self.id) { (project) in
            DispatchQueue.main.async {
                self.project = project
                print(project.getName)
                print(project.getDescription)
                self.tableView.reloadData()
            }
        }
    }
}
