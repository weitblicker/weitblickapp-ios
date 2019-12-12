//
//  RankingViewController.swift
//  Weitblick
//
//  Created by Jana  on 12.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
      

    }
    

    @IBOutlet weak var tableView: UITableView!
       
 
    let names = ["FahrerA", "FahrerB", "FahrerC"]
        let distances = ["5.4 km","6.2 km", "1.7 km","23.8 km"];
        let numbers = ["1", "2", "3"]
          
       
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return names.count
       }
    
     
          
         
          
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell =  tableView.dequeueReusableCell(withIdentifier:"ranking_cell", for: indexPath)as! RankingTableViewCell
              let distance = distances[indexPath.row]
              let number = numbers[indexPath.row]
              let name = names[indexPath.row]
              cell.distance.text = distance
              cell.number.text = number
              cell.name.text = name
             
              return cell
              
          }
    
}
