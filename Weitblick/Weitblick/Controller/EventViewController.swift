//
//  EventViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 09.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
let fruits = ["Apple", "Orange", "Peach"]
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
     func tableView(_ tableView: UITableView,
                             cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier:"event_cell", for: indexPath)as! EventTableViewCell

        // Dafür wird der Abschnitts- und Zeilenindex in einem IndexPath-Objekt übergeben
        let fruit = fruits[indexPath.row]

        // Zelle konfigurieren
       
        cell.event_image.image = UIImage(named: "Weitblick")
        cell.event_date.text = fruit
        cell.event_location.text = fruit
        cell.event_description.text = fruit
        cell.event_button_detail.tag = indexPath.row
    

        return cell
    }

    
    
   
    
override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 600
}
}

