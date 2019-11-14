//
//  ElseViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {
    
    
    

    @IBOutlet weak var blog_icon: UIImageView!
    
    @IBOutlet weak var faq_icon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blog_icon.layer.borderWidth = 3
        blog_icon.layer.borderColor = UIColor.systemOrange.cgColor
        faq_icon.layer.borderWidth = 3
        faq_icon.layer.borderColor = UIColor.systemOrange.cgColor
    
        // Do any additional setup after loading the view.
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
