//
//  NewsViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

struct ProjectData : Codable{
    let id : String?
    let start_date : String?
    let end_date : String?
    let published : String?
    let name : String?
    let slug : String?
    let hosts : [String]?
    let description : String?
    let location : Int?
    let partner : [Int]?
}




class NewsEventViewController: UIViewController {

    var projectList : [Project] = []
    
    @IBOutlet weak var segment_control: UISegmentedControl!

    @IBOutlet weak var NewsView: UIView!

    @IBOutlet weak var EventView: UIView!


    @IBAction func switchView(_ sender: UISegmentedControl) {
        self.segment_control.backgroundColor = .clear
        self.segment_control.tintColor = .clear
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
}
