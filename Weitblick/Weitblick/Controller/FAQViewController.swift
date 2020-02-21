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
    
    
    var questions1 : [FAQEntry] = []
    var questions2 : [FAQEntry] = []
    var questions3 : [FAQEntry] = []
    var questionsAll : [FAQEntry] = []
    var faq_object: FAQEntry?
    var counter_section1 = 0
    var counter_section2 = 0
    let numberOfRowsAtSection: [Int] = [5, 4]
    var arr = [[FAQEntry]]()
   
    
    let sections = ["Mitmachen & Spenden", "Struktur & Organisation","Wie benutze ich die App"]
    
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return sections[section]
       
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arr[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           self.faq_object = arr[indexPath.section][indexPath.row]
           self.performSegue(withIdentifier: "goFAQDetail", sender: self)
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"faq_cell", for: indexPath)as! FAQTableViewCell
        
        let question = arr[indexPath.section][indexPath.row].question
        cell.faq_question.text = question
        cell.faq_question.sizeToFit();
        cell.faq_answer.sizeToFit()
        return cell
         
    }
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        self.navigationController!.navigationBar.topItem!.title = "Zurück"
        FAQService.loadFAQ { (list) in
            for faq in list{
                self.questionsAll.append(faq)
                if(faq.title == "Mitmachen & Spenden"){
                self.questions1.append(faq)
            }else if (faq.title == "Struktur & Organisation"){
            self.questions2.append(faq)
                }else if (faq.title == "Wie benutze ich die App"){
                    self.questions3.append(faq)
                }
          
        }
             DispatchQueue.main.async {
                self.arr.append(self.questions1)
                self.arr.append(self.questions2)
                self.arr.append(self.questions3)
                 self.tableView.reloadData()
                 self.tableView.delegate = self
                self.tableView.dataSource = self
            }
        }
       

        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                 if segue.destination is FAQDetailViewController
                 {
                     let faqDetailViewController = segue.destination as? FAQDetailViewController
                     faqDetailViewController?.faq_object = self.faq_object
                 }
           
             }
    



}
