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
    var event_object : Event?
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //Größe der TableView abhängig von dargestellten Daten festlegen
    //Falls counter == 1 werden nur die Events die zu einem Projekt gehören dargestellt
    //-->Diese Ansicht nur sichtbar wenn man von ProjektDetail auf "Mehr anzeigen" klickt
    //Falls nicht werden alle vorhandenen Events aufgelistet
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(switch_counter == 1){
            return self.eventListProjectDetail.count
        }
        return self.eventList.count
    }

    
     func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        //Alle Events anzeigen lassen
        //Eventzelle erstellen und ihren Labels die zugehörigen Daten zuweisen
        if(self.switch_counter == 1){
        let cell = tableView.dequeueReusableCell(withIdentifier:"event_cell", for: indexPath)as! EventTableViewCell
        cell.event_date.text = eventListProjectDetail[indexPath.row].getStartDate.dateAndTimetoString()
        cell.event_host.text = eventListProjectDetail[indexPath.row].getHost.getCity.uppercased()
        cell.event_host.font = UIFont(name: "OpenSans-Bold", size: 15)
        cell.event_location.text = eventListProjectDetail[indexPath.row].getLocation.getAddress
        cell.event_description.text = eventListProjectDetail[indexPath.row].getTitle
        cell.event_image.image = eventListProjectDetail[indexPath.row].getImage
        let size = CGSize.init(width: 300  , height: 300)
        cell.event_image.image = cell.event_image.image?.crop(to: size)
        return cell
        }else{
            //Nur die Events anzeigen lassen die zu einem Projektgehören
            //Eventzelle erstellen und ihren Labels die zugehörigen Daten zuweisen
            let cell = tableView.dequeueReusableCell(withIdentifier:"event_cell", for: indexPath)as! EventTableViewCell
             cell.event_date.text = eventList[indexPath.row].getStartDate.dateAndTimetoString()
             cell.event_host.text = eventList[indexPath.row].getHost.getCity.uppercased()
             cell.event_host.font = UIFont(name: "OpenSans-Bold", size: 15)
             cell.event_location.text = eventList[indexPath.row].getLocation.getAddress
             cell.event_description.text = eventList[indexPath.row].getTitle
             cell.event_image.image = eventList[indexPath.row].getImage
             let size = CGSize.init(width: 300  , height: 300)
             cell.event_image.image = cell.event_image.image?.crop(to: size)
             return cell
        }

    }

    //Falls Zelle angeklickt wird zu EventDetailView wechseln
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.event_object = eventList[indexPath.row]
       self.performSegue(withIdentifier: "goToEventDetail", sender: self)
        
      }

    //Mithilfe des EventServices Daten laden
    //TableView erstellen
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.isUnreachable { networkManagerInstance in
          return
        }
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
    
    //EventDetailController das ausgewählte Event übergeben, damit der dieses anzeigen kann
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.destination is EventDetailViewController{
              let eventDetailViewController = segue.destination as? EventDetailViewController
              eventDetailViewController?.event_object = self.event_object
          }
      }
}

