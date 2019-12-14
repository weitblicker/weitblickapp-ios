//
//  RankingViewController.swift
//  Weitblick
//
//  Created by Jana  on 12.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    
    
    
   override func viewDidLoad() {        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    
    }
    
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
    
    
    @IBAction func indexChange(_ sender: Any) {
        
        switch self.filter_switch.selectedSegmentIndex
           {
        case 0:
            //nach km anzeigen
            print("KM FILTER ON")
            
            
             break
            
           case 1:
            //nach € anzeigen
            print("€ FILTER ON")
            
            
            break
              
           default:
               break
           }
        
        
    }
    
       
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
       }
    
     
          
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell =  tableView.dequeueReusableCell(withIdentifier:"ranking_cell", for: indexPath)as! RankingTableViewCell
              
            var distance = userList[userList.count - indexPath.row - 1].getKm
            distance = round(distance * 100 ) / 100
            cell.distance.text = distance.description + " km"
            cell.number.text = (indexPath.row + 1).description
            cell.name.text = userList[userList.count - indexPath.row - 1].getUsername
       
            cell.pimage.image = userList[userList.count - indexPath.row - 1].getImage
            
             
              return cell
              
          }
    
}
