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
        //loginWithData()
        statisticsView.alpha=0
        DestinationView.alpha=1
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
