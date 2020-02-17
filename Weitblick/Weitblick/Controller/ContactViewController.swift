//
//  ContactViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 23.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class ContactViewController: UIViewController{
    
    
    override func viewDidLoad() {
        FAQService.loadContact { (contactObject) in
             DispatchQueue.main.async {
                       
                       }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
