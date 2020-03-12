//
//  StatsViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var DestinationView: UIView!
    
    
    //View änder zwischen Rangliste und Strecken
    @IBAction func swiftView(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex==0){
            statisticsView.alpha=0
            DestinationView.alpha=1
        } else{
            statisticsView.alpha=1
            DestinationView.alpha=0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        statisticsView.alpha=0
        DestinationView.alpha=1
    }
    
}
