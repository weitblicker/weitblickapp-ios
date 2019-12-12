//
//  BlogDetailViewController.swift
//  Weitblick
//
//  Created by Jana  on 15.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class BlogDetailViewController: UIViewController {
    
    
    @IBOutlet weak var blog_detail_image: UIImageView!
    
    @IBOutlet weak var blog_detail_title: UILabel!
    
    @IBOutlet weak var blog_detail_date: UILabel!
      
    
    @IBOutlet weak var blog_detail_description: UILabel!
    
     @IBOutlet var photoSliderView: PhotoSliderView!
     
    var blog_object : BlogEntry?
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
      blog_detail_title.text = blog_object?.getTitle
      blog_detail_description.text = blog_object?.getText.html2String
      blog_detail_description.sizeToFit()
        
      
        blog_detail_date.text = blog_object?.getCreationDate.dateAndTimetoString()
        print("Test1")
       // blog_detail_image.image = self.image
      
        let defaultstring = "https://new.weitblicker.org"
        var images: [UIImage] = []
        if(blog_object?.getGallery.images?.count != 0){
            for image in (self.blog_object?.getGallery.images)!{
                let imgURL = NSURL(string : defaultstring + image.imageURL!)
                let data = NSData(contentsOf: (imgURL as URL?)!)
                images.append(UIImage(data : data! as Data)!)
            }
            photoSliderView.configure(with: images)
        }else{
            //photoSliderView.alpha = 0.0
            guard let image = UIImage(named : "Weitblick") else { return }
            images.append(image)
            photoSliderView.configure(with: images)
        }
    }
}
