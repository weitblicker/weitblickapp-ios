//
//  CreditViewController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 17.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit
import MarkdownKit

class CreditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Tabellengröße der Entwickler festlegen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.memberList.count
    }
    
    //Creditzelle erstellen und ihren labels die Daten zuweisen
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"creditCell", for: indexPath)as! CreditTableViewCell
        cell.credit_email.text = memberList[indexPath.row].getEmail
        cell.credit_img.image = memberList[indexPath.row].getImage
        cell.credit_name.text = memberList[indexPath.row].getName
        cell.credit_role.text = memberList[indexPath.row].getRole
        cell.credit_text.text = memberList[indexPath.row].getText
        return cell
    }
    
    var memberList : [Member] = []
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var creditDescription: UILabel!
    @IBOutlet weak var creditTitle: UILabel!
    
    //TableView laden
    //Daten vom FAQService laden und in den Labels darstellen
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        FAQService.loadCredits { (creditObject,error)  in
            if let creditObject = creditObject{
                DispatchQueue.main.async {
                self.imageView.image = creditObject.getImage
                self.creditTitle.text = creditObject.getName
                let markdownParser = MarkdownParser()
                self.creditDescription.attributedText = markdownParser.parse(creditObject.getDescription)
                self.creditDescription.sizeToFit()
                for member in creditObject.getMembers{
                    self.memberList.append(member)
                }
                    self.tableView.reloadData()
                }
            }else{
                if let error = error{
                    print(error)
                }
            }
            
        }
    }

}
