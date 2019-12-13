//
//  ResultMapViewController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit


class ResultMapViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate  {
    

    var DistanceText = String()
    var DonationText = String()
    var project: Project?
    
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var totalDonation: UILabel!
    
    @IBOutlet weak var projectTitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
      let names = ["SponsorA", "SponsorB", "SponsorC","SponsorD"]
      
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return names.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell =  tableView.dequeueReusableCell(withIdentifier:"sponsor_cell", for: indexPath)as! SponsorTableViewCell
          let name = names[indexPath.row]
          cell.name.text = name
          cell.spon_image.image = UIImage(named: "weitblickLogoCircle")
          return cell
          
      }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        totalDistance.text = DistanceText
        totalDonation.text = DonationText
        if(UserDefaults.standard.string(forKey: "projectName") != nil){
        self.projectTitle.text = UserDefaults.standard.string(forKey: "projectName")
        }else{
           self.projectTitle.text = "Kein Projekt ausgewählt"
        }
    
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        print("Button clicked")
        dismiss(animated: true, completion: nil)
    }
    
}
