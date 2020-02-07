//
//  ProjectBlogViewController.swift
//  Weitblick
//
//  Created by Jana  on 10.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class ProjectBlogViewController: UIViewController {

    @IBOutlet weak var ProjectView: UIView!
    @IBOutlet weak var BlogView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

             ProjectView.alpha=1
             BlogView.alpha=0
    }
    

    @IBAction func switchView(_ sender: UISegmentedControl) {
           if(sender.selectedSegmentIndex==0){
               ProjectView.alpha=1
               BlogView.alpha=0
           } else{
               ProjectView.alpha=0
               BlogView.alpha=1
           }
       }


}
