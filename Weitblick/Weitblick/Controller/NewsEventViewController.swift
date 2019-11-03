//
//  NewsViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class NewsEventViewController: UIViewController {
    
    
    
    @IBOutlet weak var NewsView: UIView!
    
    
    @IBOutlet weak var EventView: UIView!
    
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex==0){
            NewsView.alpha=1
            EventView.alpha=0
        } else{
            NewsView.alpha=0
            EventView.alpha=1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewsView.alpha=1
        EventView.alpha=0
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
