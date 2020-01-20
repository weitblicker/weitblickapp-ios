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
    var partnerList: [String] = ["Osnabrück","Münster", "Köln", "Berlin"]
    var locationList: [String] = ["Grüner Jäger", "Domplatz", "Kölner Dom", "Brandenburger Tor"]
    var dateList: [String] = ["20.02.2020", "01.01.2020", "05.03.2020","16.09.2020"]
    var titleList: [String] = ["Stammtisch im Jäger", "Flunkyballturnier", "Stadtrallye", "Sommerfest"]

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1

    }

     func tableView(_ tableView: UITableView,
                             cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier:"event_cell", for: indexPath)as! EventTableViewCell
        cell.event_date.text = dateList[indexPath.row]
        cell.event_host.text = partnerList[indexPath.row]
        cell.event_location.text = locationList[indexPath.row]
        cell.event_description.text = titleList[indexPath.row]
        cell.event_image.image = UIImage(named: "Weitblick")
        return cell

    }


//    override func viewDidAppear(_ animated: Bool) {
//          let tabbar = tabBarController.self as! TabBarController
//              tabbar.loadData()
//              tableView.reloadData()
//    }


override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 600
 }
}

