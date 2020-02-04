//
//  BlogDetailViewController.swift
//  Weitblick
//
//  Created by Jana  on 15.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import MarkdownKit

class BlogDetailViewController: UIViewController {
    
    
    @IBOutlet weak var triangle: UILabel!
    
    @IBOutlet weak var blog_detail_image: UIImageView!
    
    @IBOutlet weak var blog_detail_country: UILabel!
    
    @IBOutlet weak var blog_detail_title: UILabel!
    
    @IBOutlet weak var blog_detail_date: UILabel!
      
    
    @IBOutlet weak var blog_detail_description: UILabel!
    
     @IBOutlet var photoSliderView: PhotoSliderView!
     
    var blog_object : BlogEntry?
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         triangle.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
        loadDetailBlog()
        self.navigationController!.navigationBar.topItem!.title = "Zurück"
        
    
        
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
      
    
    func loadDetailBlog(){

        let markdownParser = MarkdownParser()
        blog_detail_description.attributedText = markdownParser.parse(blog_object!.getText)
        blog_detail_title.text = blog_object?.getTitle
        blog_detail_description.sizeToFit()
        blog_detail_date.text = blog_object?.getCreationDate.dateAndTimetoString()
        blog_detail_country.text = "Indien"
        // blog_detail_image.image = self.image

        photoSliderView.configure(with: [])

    }
}
