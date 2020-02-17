//
//  ContactViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 23.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit
import MarkdownKit

class ContactViewController: UIViewController{
    
    @IBOutlet weak var contact_title: UILabel!
    
    @IBOutlet weak var contact_description: UILabel!
    @IBOutlet weak var contact_image: UIImageView!
    
    
    override func viewDidLoad() {
        print("IN CONTACT VIEW CONTROLLER")
        let markdownParser = MarkdownParser()
        FAQService.loadContact { (contactObject) in
             DispatchQueue.main.async {
                self.contact_title.text =
                contactObject.getTitle
                print(contactObject.getTitle)
                self.contact_title.sizeToFit()
                self.contact_image.image =
                contactObject.getImage
                self.contact_description.attributedText =
                markdownParser.parse(contactObject.getText)
                self.contact_description.sizeToFit()
                
                       
                       }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
