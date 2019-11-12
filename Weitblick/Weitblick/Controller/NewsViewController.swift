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
    
    
    var newsList : [NewsEntry] = []
    @IBOutlet weak var tableView: UITableView!
    let fruits = ["Apple", "Orange", "Peach"]
    
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tabbar = tabBarController.self as! TabBarController
        print(tabbar.newsCollection.getNewsList.count)
        return tabbar.newsCollection.getNewsList.count
    }
    
     func tableView(_ tableView: UITableView,
                             cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        
       let tabbar = tabBarController.self as! TabBarController
        
        print("Hallo1")
        let cell = tableView.dequeueReusableCell(withIdentifier:"news_cell", for: indexPath)as! NewsTableViewCell
        
        // Zelle konfigurieren
        cell.news_image.image = UIImage(named: "Weitblick")

        cell.news_description.text = tabbar.newsCollection.getNewsList[indexPath.row].getTitle
        cell.news_button_detail.tag = indexPath.row
        
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        let tabbar = tabBarController.self as! TabBarController
        tabbar.loadData()
        //self.newsList = tabbar.newsCollection.getNewsList
        tableView.reloadData()
    }
   
override func viewDidLoad() {
    
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 600

    // Do any additional setup after loading the view.
}
}
