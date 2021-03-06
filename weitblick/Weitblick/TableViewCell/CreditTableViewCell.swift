//
//  CreditTableViewCell.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 17.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

//Zelle für Tabelle auf CreditsController 

import UIKit

class CreditTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var credit_img: UIImageView!
    @IBOutlet weak var credit_name: UILabel!
    @IBOutlet weak var credit_role: UILabel!
    @IBOutlet weak var credit_text: UILabel!
    @IBOutlet weak var credit_email: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
