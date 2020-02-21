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
        let markdownParser = MarkdownParser()
        FAQService.loadContact { (contactObject, error) in
            if let contactObject = contactObject{
                DispatchQueue.main.async {
                     self.contact_title.text =
                     contactObject.getTitle
                     self.contact_title.sizeToFit()
                     self.contact_image.image =
                     contactObject.getImage
                     self.contact_description.attributedText =
                     markdownParser.parse(contactObject.getText)
                     self.contact_description.sizeToFit()
                }
            }else{
                if let error = error{
                    print(error)
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
