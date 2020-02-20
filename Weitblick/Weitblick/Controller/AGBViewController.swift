//
//  AGBViewController.swift
//  Weitblick
//
//  Created by Jana  on 13.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import MarkdownKit

class AGBViewController: UIViewController {


    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var agb_image: UIImageView!
    
    @IBOutlet weak var agb_title: UILabel!
    
    override func viewDidLoad() {
        let markdownParser = MarkdownParser()
        
        FAQService.loadAGBS { (agbObject, error) in
            if let agbObject = agbObject{
                DispatchQueue.main.async {
                    self.textLabel.attributedText = markdownParser.parse(agbObject.getText)
                self.agb_image.image = agbObject.getImage
                self.agb_title.text = agbObject.getTitle
                self.textLabel.sizeToFit()
                }
            }else{
                if let error = error{
                    print(error.description)
                }
            }
        }
         super.viewDidLoad()
         
     }

}
