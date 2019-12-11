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
    
    
    var questions : [FAQEntry] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"faq_cell", for: indexPath)as! FAQTableViewCell
        let question = questions[indexPath.row].question
        let answer = questions[indexPath.row].answer
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
        print("FAQService executing")
        FAQService.loadFAQ { (list) in
            for faq in list{
                self.questions.append(faq)
            }
            self.tableView.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    



}
