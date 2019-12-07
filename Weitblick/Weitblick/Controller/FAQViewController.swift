//
//  FAQController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import Foundation

class FAQViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    let questions = ["Was ist Weitblick", "Wann wurde Weitblick gegründet", "Wieviele Mitarbeiter hat die Organisation"]
    let answers = ["Weitblick ist eine Spendenorganisation die sich vor allem für Bildung einsetzt", "Sie wurde im Jahr .. gegründet und feiert somit in .. Jahren schon 20 Jubiläum", "Bei Weitblick sind heutzutage genau .. Mitarbeiter angestellt"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier:"faq_cell", for: indexPath)as! FAQTableViewCell
        let question = questions[indexPath.row]
        let answer = answers [indexPath.row]
        cell.faq_question.text = question
        cell.faq_answer.text = answer
        cell.faq_answer.sizeToFit()
        return cell
         
        
    }
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController!.navigationBar.topItem!.title = "Zurück"

        // Do any additional setup after loading the view.
    }
    



}
