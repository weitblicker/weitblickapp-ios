//
//  ProjectViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    let fruits = ["Apple", "Orange", "Peach","hahha"]
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return fruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableViewCell
      
        // Dafür wird der Abschnitts- und Zeilenindex in einem IndexPath-Objekt übergeben
        let fruit = fruits[indexPath.row]

        // Zelle konfigurieren
       // cell.project_title.text = fruit
        print(fruit)
        cell.imageView?.image = UIImage(named:"Weitblick")
        cell.project_title.text = fruit
        
      return cell
    }
    
    @objc func bikeTapped(_ sender: UIButton){
      // use the tag of button as index
      let alert = UIAlertController(title: "Ausgewählt!", message: "Subscribed to Project", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(okAction)
            
      self.present(alert, animated: true, completion: nil)
    }
    

    

  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
