//
//  NewsDetailViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
//NEWS Variablen
   
    @IBOutlet weak var news_detail_loaction: UILabel!
    @IBOutlet weak var news_detail_date: UILabel!
    @IBOutlet weak var news_detail_title: UILabel!
    @IBOutlet weak var news_detail_description: UILabel!
    
    @IBOutlet weak var news_detail_image: UIImageView!
    
    //EVENT Variablen
  
    var news_object : NewsEntry?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewsDetail()
      
        
        // Do any additional setup after loading the view.
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
              news_detail_description.text = news_object?.getText
              news_detail_date.text = news_object?.getCreationDate.description
              news_detail_title.text = news_object?.getTitle
              news_detail_loaction.text = "Osnabrück"
              let defaultstring = "https://new.weitblicker.org"
              let imgURL = NSURL(string : defaultstring + news_object!.getImageURL)
              if(imgURL != nil){
                  let data = NSData(contentsOf: (imgURL as URL?)!)
                  news_detail_image.image = UIImage(data: data! as Data)
              }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
