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
    
    var eventList : [Event] = []
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tabbar = tabBarController.self as! TabBarController
        print("In Event TableView")
        print(tabbar.eventCollection.getEventList.count)
        return tabbar.eventCollection.getEventList.count
      
    }
    
     func tableView(_ tableView: UITableView,
                             cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier:"event_cell", for: indexPath)as! EventTableViewCell
        let tabbar = tabBarController.self as! TabBarController
        cell.event_image.image = UIImage(named: "Weitblick")
        cell.event_description.text = tabbar.eventCollection.getEventList[indexPath.row].getName
        cell.event_button_detail.tag = indexPath.row
        return cell
    }

    
    override func viewDidAppear(_ animated: Bool) {
          let tabbar = tabBarController.self as! TabBarController
              tabbar.loadData()
              tableView.reloadData()
    }
   
    
override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 600
 }
}

