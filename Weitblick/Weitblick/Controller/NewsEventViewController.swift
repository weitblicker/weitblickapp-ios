//
//  NewsViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

struct ProjectData : Codable{
    let id : String?
    let start_date : String?
    let end_date : String?
    let published : String?
    let name : String?
    let slug : String?
    let hosts : [String]?
    let description : String?
    let location : Int?
    let partner : [Int]?
}


class NewsEventViewController: UIViewController {

    var projectList : [Project] = []


    @IBOutlet weak var NewsView: UIView!

    @IBOutlet weak var EventView: UIView!


    @IBAction func switchView(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex==0){
            NewsView.alpha=1
            EventView.alpha=0



        } else{
            NewsView.alpha=0
            EventView.alpha=1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //loginWithData()
        NewsView.alpha=1
        EventView.alpha=0
    }


  /*  private func loginWithData(){

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
                    //            let project = Project(id : id, published: <#Date#>,name : name, gallery: <#[String]#>,hosts : hosts,description : description,locationID : locationID,partnerID :partnerID)
                      //        self.projectList.append(project)

                            }

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


    }*/




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
