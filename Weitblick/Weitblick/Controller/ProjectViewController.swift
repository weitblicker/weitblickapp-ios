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
    return projectList.count    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {   // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableViewCell
   
        // Dafür wird der Abschnitts- und Zeilenindex in einem IndexPath-Objekt übergeben
        let fruit = fruits[indexPath.row]

        // Zelle konfigurieren
       // cell.project_title.text = fruit
        print(fruit)
        cell.imageView?.image = UIImage(named:"Weitblick")
      /*  cell.project_title.text = fruit
        cell.project_description.text = fruit
        cell.project_location.text = fruit*/
        cell.project_button_detail.tag = indexPath.row
       
        
        cell.project_title.text = projectList[indexPath.row].getName
        print(cell.project_title.text ?? " ERROR")
       // cell.project_location.text = projectList[indexPath.row].getDescription
        cell.project_description.text = projectList[indexPath.row].getDescription
        print(cell.project_description.text ?? "ERROR ")
        
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
         getProjectData()
    }
    

    
    
 
 
     private func getProjectData(){

        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url: URL(string: "https://new.weitblicker.org/rest/projects/?limit=3")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
            do {
                let options = JSONSerialization.WritingOptions.prettyPrinted
                do {
                    let data = try JSONSerialization.data(withJSONObject: responseJSON as Any, options: options)
                    if let string = String(data: data, encoding: String.Encoding.utf8) {
                        let data = string.data(using: .utf8)!
                        //print(string)
                        do {
                            let f = try JSONDecoder().decode([ProjectData].self, from: data)
                            //print(f)
                            for project in f {
                                guard let id = Int.init(project.id!) else { return }
                                guard let name = project.name else { return }
                                guard let hosts = project.hosts else { return }
                                guard let description = project.description else { return }
                                guard let locationID = project.location else { return }
                                let partnerID = project.partner ?? []
                                
                           //     let project = Project(id : id,published: "12.12.12",name : name,hosts : hosts,description : description,locationID : locationID,partnerID :partnerID)
                           //    self.projectList.append(project)
                                
                               
            
                            }
                  //          self.tableView.reloadData()
                            
                        } catch {
                            print(error)
                        }
                        
                        
                    }
                } catch {
                  print(error)
                }
            }
        })
        

        task.resume()

        
    }
    



}
