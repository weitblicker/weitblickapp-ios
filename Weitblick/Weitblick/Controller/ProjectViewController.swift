//
//  ProjectViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var projectList : [Project] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    let fruits = ["Apple", "Orange", "Peach","hahha"]
    
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fruits.count    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {   // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableViewCell
   
        // Dafür wird der Abschnitts- und Zeilenindex in einem IndexPath-Objekt übergeben
        let fruit = fruits[indexPath.row]

        // Zelle konfigurieren
       // cell.project_title.text = fruit
        print(fruit)
        cell.imageView?.image = UIImage(named:"Weitblick")
        cell.project_title.text = fruit
        cell.project_description.text = fruit
        cell.project_location.text = fruit
        cell.project_button_detail.tag = indexPath.row
       
        
     //   cell.project_title.text = projectList[indexPath.row].getName
      //  print(cell.project_title.text ?? " ERROR")
       // cell.project_location.text = projectList[indexPath.row].getDescription
        //cell.project_description.text = projectList[indexPath.row].getDescription
       // print(cell.project_description.text ?? "ERROR ")
        
      return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
          tableView.rowHeight = UITableView.automaticDimension
          tableView.estimatedRowHeight = 600
      }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    


    



}
