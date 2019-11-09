//
//  NewsViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 04.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
   
    

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
        let cell = tableView.dequeueReusableCell(withIdentifier:"news_cell", for: indexPath)as! NewsTableViewCell

        // Dafür wird der Abschnitts- und Zeilenindex in einem IndexPath-Objekt übergeben
        let fruit = fruits[indexPath.row]

        // Zelle konfigurieren
        let text = fruits[indexPath.row]
        cell.news_image.image = UIImage(named: "Weitblick")
        cell.news_date.text = fruit
        cell.news_location.text = fruit
        cell.news_description.text = fruit

        return cell
    }

override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self

    // Do any additional setup after loading the view.
}
}
