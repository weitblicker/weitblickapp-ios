//
//  ResultMapViewController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class ResultMapViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
      let names = ["SponsorA", "SponsorB", "SponsorC","SponsorD"]
      
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return names.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell =  tableView.dequeueReusableCell(withIdentifier:"sponsor_cell", for: indexPath)as! SponsorTableViewCell
          let name = names[indexPath.row]
          cell.name.text = name
          return cell
          
      }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
