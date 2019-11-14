//
//  FAQTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 14.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit


class FAQTableViewCell: UITableViewCell{
    

    @IBOutlet weak var faq_question: UILabel!
    
    @IBOutlet weak var faq_answer: UILabel!
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

   override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
