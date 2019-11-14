//
//  BlogViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 14.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class BlogViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var tableView: UITableView!
    
    let blogs = ["Blog Thema A", "Blog Thema B", "WBlog Thema C"]
    let dates = ["12.12","13.13","14.14"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier:"blog_cell", for: indexPath)as! BlogTableViewCell
        let blog = blogs[indexPath.row]
        let date = dates[indexPath.row]
        cell.blog_image.image = UIImage(named:"Weitblick")
        cell.blog_description.text = blog
        cell.blog_date.text = date
        
        print(cell.blog_description.text)
        
        return cell
         
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    


}
