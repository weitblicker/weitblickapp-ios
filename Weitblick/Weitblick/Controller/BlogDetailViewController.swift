//
//  BlogDetailViewController.swift
//  Weitblick
//
//  Created by Jana  on 15.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import MarkdownKit

class BlogDetailViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate{
    
    
   
    
    
    
    
    
    
    @IBOutlet weak var triangle: UILabel!
    
    @IBOutlet weak var blog_detail_image: UIImageView!
    
    @IBOutlet weak var blog_detail_country: UILabel!
    
    @IBOutlet weak var blog_detail_title: UILabel!
    
    @IBOutlet weak var blog_detail_date: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var project_label: UILabel!
    
    
    @IBOutlet weak var blog_detail_author_img: UIImageView!
    @IBOutlet weak var blog_detail_author_name: UILabel!
    
    @IBOutlet weak var blog_detail_description: UILabel!
    @IBOutlet weak var blog_detail_host: UILabel!
    
     @IBOutlet var photoSliderView: PhotoSliderView!
     
    var blog_object : BlogEntry?
    var image : UIImage?
    var id = -1
    var project : Project?
    
    @IBOutlet weak var marker: UIImageView!
    
    @IBOutlet weak var orangeLabel: UILabel!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
         triangle.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
    
           loadDetailBlog()
        
        
        self.navigationController!.navigationBar.topItem!.title = "Zurück"
        
        if(blog_object!.getprojectInt != 0){
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }else{
            self.tableView.alpha = 0
            self.project_label.text = ""
            orangeLabel.alpha = 0
        }
        
        if(blog_object!.getLocation.getAddress == ""){
            marker.alpha = 0
           }
       
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier:"blogproject_cell", for: indexPath)as! BlogDetailProjectCell
        
        print("IN TABLEVIEW")
        //cell.project_image!.image = UIImage (named: "Weitblick")
        cell.project_image!.image = self.project?.getImage
        cell.project_title.text = self.project?.getName
        cell.project_partner.text = "Partner"
        cell.project_location.text = self.project?.getLocation.getAddress
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           self.performSegue(withIdentifier: "goToProjectDetail", sender: self)
       }
    
    public func loadProject(){
        print("IN LOADPROJECTS1")
        self.id = blog_object!.getprojectInt
        print("PROJECT ID")
        print(blog_object!.getprojectInt)
        DataService.getProjectWithID(id: self.id) { (project) in
                self.project = project
                print("IN LOADPROJECTS2")
                print (self.project?.getName as Any)
            DispatchQueue.main.async {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                
            }
               
           }
           
       }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              if segue.destination is ProjectDetailViewController
              {
                  let projectDetailViewController = segue.destination as? ProjectDetailViewController
                  projectDetailViewController?.project_object = self.project
                  

              }
        
          }

    
    
    override func viewWillAppear(_ animated: Bool) {
          let nav = self.navigationController?.navigationBar

          nav?.barStyle = UIBarStyle.default
          
          let imageView = UIImageView(frame : CGRect(x : 0 , y : 0, width : 40 , height : 40))
          imageView.contentMode = .scaleAspectFit
          
          let image = UIImage(named : "Weitblick")
          imageView.image = image
          
          navigationItem.titleView = imageView
        if(blog_object!.getprojectInt != 0){
              loadProject()
        }
       
        

      }
      
    
    func loadDetailBlog(){
        //Datum, Stadt

        let markdownParser = MarkdownParser()
        blog_detail_description.attributedText = markdownParser.parse(blog_object!.getText)
        blog_detail_title.text = blog_object?.getTitle
        blog_detail_description.sizeToFit()
        blog_detail_date.text = blog_object?.getCreationDate.dateAndTimetoString()
        blog_detail_country.text = blog_object?.getLocation.getAddress
        blog_detail_author_name.text = blog_object?.getAuthor.getName
        blog_detail_author_img.image = blog_object?.getAuthor.getImage
        blog_detail_host.text = blog_object?.getHost.getName
        
        
        
        
        // blog_detail_image.image = self.image

        photoSliderView.configure(with: blog_object!.getGallery)

    }
    
   
}
