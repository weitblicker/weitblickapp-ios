//
//  RouteViewController.swift
//  Weitblick
//
//  Created by Jana  on 26.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
   
    @IBOutlet weak var tableView: UITableView!
    let routes = ["5.4 km","6.2 km", "1.7 km","23.8 km"];
    let donatations = ["5,5 €", "6,5 €", "2€","24 €"]
    let times = ["45 min", "52 min", "17 min","46 min"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier:"route_cell", for: indexPath)as! RouteTableViewCell
        let route = routes[indexPath.row]
        let donation = donatations[indexPath.row]
        let time = times[indexPath.row]
        cell.route.text = route
        cell.donation.text = donation
        cell.time.text = time
        cell.date.text = "24.12.19"
        return cell
        
    }
    

     override func viewDidLoad() {
           super.viewDidLoad()
     
/*        self.tableView.dataSource = self
        self.tableView.delegate = self*/

           // Do any additional setup after loading the view.
       }
       

}

