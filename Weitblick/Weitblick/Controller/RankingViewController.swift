//
//  RankingViewController.swift
//  Weitblick
//
//  Created by Jana  on 12.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    
    var filter = 1;
  
   override func viewDidLoad() {        
       super.viewDidLoad()
   }

    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
     }
    
    //Daten für Ranking laden vom RankingService
    func loadData(){
        userList = []
        RankingService.getRankings { (list) in
            for user in list{
                self.userList.append(user)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var userList : [User] = []
    @IBOutlet weak var filter_switch: UISegmentedControl!
    
    //TableView je nach Switch Auswahl anzeigen lassen
    @IBAction func indexChange(_ sender: Any) {
        switch self.filter_switch.selectedSegmentIndex
           {
        case 1:
             //nach € anzeigen
            self.filter = 0
            self.tableView.reloadData()
            break
            
           case 0:
            //nach km anzeigen
            self.filter = 1
            userList.sort {
                $0.getKm > $1.getKm
            }
            self.tableView.reloadData()
            break
              
           default:
               break
           }
    }
    
       
    //TableView Größe festlegen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
       }
    
    //Rankingzelle erstellen
    //Den Labels Werte zuweisen
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier:"ranking_cell", for: indexPath)as! RankingTableViewCell
        var distance = userList[indexPath.row].getKm
        distance = round(distance * 100 ) / 100
        var donation = userList[indexPath.row].getEuro
        donation = round(donation * 100)/100
        
        if(self.filter == 1){
            cell.distance.text = distance.description + " km"
            }else if(self.filter == 0){
                cell.distance.text = donation.description + " €"
        }
        cell.number.text = (indexPath.row+1).description
        cell.name.text = userList[indexPath.row].getUsername
        cell.pimage.image = userList[indexPath.row].getImage
        return cell
        
    }
    
}
