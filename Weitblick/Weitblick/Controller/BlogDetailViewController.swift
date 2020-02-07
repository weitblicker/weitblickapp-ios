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



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }





    @IBOutlet weak var triangle: UILabel!

    @IBOutlet weak var blog_detail_image: UIImageView!

    @IBOutlet weak var blog_detail_country: UILabel!

    @IBOutlet weak var blog_detail_title: UILabel!

    @IBOutlet weak var blog_detail_date: UILabel!

    @IBOutlet weak var tableView: UITableView!



    @IBOutlet weak var blog_detail_description: UILabel!

     @IBOutlet var photoSliderView: PhotoSliderView!

    var blog_object : BlogEntry?
    var image : UIImage?
    var id = -1
    var project : Project?

    override func viewDidLoad() {


        super.viewDidLoad()
         triangle.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
        loadDetailBlog()
        self.navigationController!.navigationBar.topItem!.title = "Zurück"

        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600



    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier:"blogproject_cell", for: indexPath)as! BlogDetailProjectCell

        print("IN TABLEVIEW")
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

    public func loadProject(){
        print("IN LOADPROJECTS1")
        self.id = blog_object!.getprojectInt
        print("PROJECT ID")
        print(blog_object!.getprojectInt)
        DataService.getProjectWithID(id: self.id) { (project) in

                   self.project = project
                print("IN LOADPROJECTS2")
                print (self.project?.getName)
                 //  self.performSegue(withIdentifier: "goToMapView", sender: self)

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
         loadProject()


      }


    func loadDetailBlog(){

        let markdownParser = MarkdownParser()
        blog_detail_description.attributedText = markdownParser.parse(blog_object!.getText)
        blog_detail_title.text = blog_object?.getTitle
        blog_detail_description.sizeToFit()
        blog_detail_date.text = blog_object?.getCreationDate.dateAndTimetoString()
        blog_detail_country.text = "Indien"
        // blog_detail_image.image = self.image

        photoSliderView.configure(with: blog_object!.getGallery)

    }
}
