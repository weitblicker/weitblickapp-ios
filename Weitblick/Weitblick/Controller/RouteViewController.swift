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
    var routeList : [RouteEntry] = []
    
    //TableView Größe festlegen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeList.count
    }
    //Routezelle erstellen und Variablen den Labels zuweisen
    //Liste nach Datum sortieren
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier:"route_cell", for: indexPath)as! RouteTableViewCell
        
        routeList.sort {
        $0.getDate.dateAndTimetoString() > $1.getDate.dateAndTimetoString()
        }
        
        var distance = routeList[indexPath.row].getDistance
        distance = round(distance*100)/100
        cell.route.text = distance.description + " km"
        cell.route.textAlignment = NSTextAlignment.right
        var donation = routeList[indexPath.row].getDonation
        donation = round(donation*100)/100
        cell.donation.text = donation.description + " €"
        cell.time.text = routeList[indexPath.row].getDuration.description.handleTime + " h"
        cell.date.text = routeList[indexPath.row].getDate.dateAndTimetoStringRoutes()
        return cell
        
    }

    //RouteServices starten
    //TableView laden
     override func viewDidLoad() {
           super.viewDidLoad()
        RouteService.getRoutes { (list) in
            for entry in list{
                self.routeList.append(entry)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
       }
       

}

