//
//  AGBViewController.swift
//  Weitblick
//
//  Created by Jana  on 13.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class AGBViewController: UIViewController {

 
    

    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var agb_image: UIImageView!
    
    @IBOutlet weak var agb_title: UILabel!
    
    override func viewDidLoad() {
        
        FAQService.loadAGBS { (agbObject) in
            self.textLabel.text = agbObject.getText
            self.agb_image.image = agbObject.getImage
            self.agb_title.text = agbObject.getTitle
            self.textLabel.sizeToFit()
        }
         super.viewDidLoad()
         print("IN AGB")
         

         // Do any additional setup after loading the view.
     }

}
