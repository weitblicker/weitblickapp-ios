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
    
    @IBOutlet weak var project_city: UILabel!
    
    @IBOutlet weak var projectTitle: UILabel!
    
    @IBOutlet weak var project_location: UILabel!
    var counter = 0
    
    
    @IBOutlet weak var project_image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var hostList : String = ""
      let names = ["SponsorA", "SponsorB", "SponsorC","SponsorD"]
      
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.project?.getCycleObject.getDonations.count)!
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell =  tableView.dequeueReusableCell(withIdentifier:"sponsor_cell", for: indexPath)as! SponsorTableViewCell
         // let name = names[indexPath.row]
        if(self.counter < (self.project?.getCycleObject.getDonations.count)!){
            cell.name.text = self.project?.getCycleObject.getDonations[self.counter].getSponsor.getName
                  cell.spon_image.image = self.project?.getCycleObject.getDonations[self.counter].getSponsor.getLogo
            counter = counter + 1
            return cell
        }
      return cell
          
      }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        totalDistance.text = DistanceText
        totalDonation.text = DonationText
        if(UserDefaults.standard.string(forKey: "projectName") != nil){
        self.projectTitle.text = UserDefaults.standard.string(forKey: "projectName")
            self.project_image.image = self.project?.getImageOrigin
            
        }else{
           self.projectTitle.text = "Kein Projekt ausgewählt"
        }
        self.project_location.text = self.project?.getLocation.getAddress
        for host in self.project!.getHosts{
            if(self.project!.getHosts.count > 1){
                self.hostList = self.hostList + host.getCity.uppercased() + ","
            }else{
                self.hostList = self.hostList + host.getCity.uppercased()
            }
        }
        self.project_city.text = self.hostList
        
    
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        print("Button clicked")
        dismiss(animated: true, completion: nil)
    }
    
}
