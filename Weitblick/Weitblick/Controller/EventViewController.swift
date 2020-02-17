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
    
    var date : Date = Date()


    @IBOutlet weak var tableView: UITableView!

    var eventList : [Event] = []
    var eventListProjectDetail: [Event] = []
    var switch_counter = 0
//    var partnerList: [String] = ["Osnabrück","Münster", "Köln", "Berlin"]
//    var locationList: [String] = ["Grüner Jäger", "Domplatz", "Kölner Dom", "Brandenburger Tor"]
//    var dateList: [String] = ["20.02.2020", "01.01.2020", "05.03.2020","16.09.2020"]
//    var titleList: [String] = ["Stammtisch im Jäger", "Flunkyballturnier", "Stadtrallye", "Sommerfest"]
  var event_object : Event?
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(switch_counter == 1){
            return self.eventListProjectDetail.count
        }
        return self.eventList.count

    }

     func tableView(_ tableView: UITableView,
                             cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        if(self.switch_counter == 1){
        let cell = tableView.dequeueReusableCell(withIdentifier:"event_cell", for: indexPath)as! EventTableViewCell
        cell.event_date.text = eventListProjectDetail[indexPath.row].getStartDate.dateAndTimetoString()
        cell.event_host.text = eventListProjectDetail[indexPath.row].getHost.getCity.uppercased()
        cell.event_location.text = eventListProjectDetail[indexPath.row].getLocation.getAddress
        cell.event_description.text = eventListProjectDetail[indexPath.row].getTitle
        cell.event_image.image = eventListProjectDetail[indexPath.row].getImage
        let size = CGSize.init(width: 300  , height: 300)
        cell.event_image.image = cell.event_image.image?.crop(to: size)
        return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier:"event_cell", for: indexPath)as! EventTableViewCell
             cell.event_date.text = eventList[indexPath.row].getStartDate.dateAndTimetoString()
             cell.event_host.text = eventList[indexPath.row].getHost.getCity.uppercased()
             cell.event_location.text = eventList[indexPath.row].getLocation.getAddress
             cell.event_description.text = eventList[indexPath.row].getTitle
             cell.event_image.image = eventList[indexPath.row].getImage
             let size = CGSize.init(width: 300  , height: 300)
             cell.event_image.image = cell.event_image.image?.crop(to: size)
             return cell
        }

    }


//    override func viewDidAppear(_ animated: Bool) {
//          let tabbar = tabBarController.self as! TabBarController
//              tabbar.loadData()
//              tableView.reloadData()
//    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.event_object = eventList[indexPath.row]
       self.performSegue(withIdentifier: "goToEventDetail", sender: self)
        
      }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(eventListProjectDetail.count > 0){
                   self.switch_counter = 1
               }
        EventService.loadEvents(date: date) { (list) in
            self.eventList = list
            self.date = self.eventList.last!.getStartDate
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 600
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.destination is EventDetailViewController{
              let eventDetailViewController = segue.destination as? EventDetailViewController
              eventDetailViewController?.event_object = self.event_object
          }
      }
}

