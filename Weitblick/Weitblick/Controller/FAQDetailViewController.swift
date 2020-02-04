//
//  FAQDetailViewController.swift
//  Weitblick
//
//  Created by Jana  on 02.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class FAQDetailViewController: UIViewController {
    
    var faq_object: FAQEntry?

 
    @IBOutlet weak var answer: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.answer.text = faq_object?.answer
        self.answer.sizeToFit()
      
    }
    


}
