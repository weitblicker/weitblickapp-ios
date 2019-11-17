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
    
    var blog_object : BlogEntry?
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetailBlog()

        
    }
    func loadDetailBlog(){
        
        blog_detail_title.text = blog_object?.getTitle
        blog_detail_description.text = blog_object?.getText
        blog_detail_description.sizeToFit()
        print(blog_detail_description.text)
        blog_detail_date.text = blog_object?.getCreationDate.dateAndTimetoString()
        print("Test1")
       // blog_detail_image.image = self.image
      
        let defaultstring = "https://new.weitblicker.org"
       let imgURL = NSURL(string : defaultstring + blog_object!.getImageMainURL)
        if(imgURL != nil){
            let data = NSData(contentsOf: (imgURL as URL?)!)
            if(data == nil){
                print("Test2")
                blog_detail_image.image = UIImage(named: "Weitblick")
            }else{
                print("Test3")
            blog_detail_image.image = UIImage(data: data! as Data)
            }
            print("Test4")
        }
        
        
        
        
    }
    

    
}
