//
//  FAQTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 14.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//


//Zelle für Liste von Fragen und Antworten für FAQ
import Foundation
import UIKit


class FAQTableViewCell: UITableViewCell{
    

    @IBOutlet weak var faq_question: UILabel!
    @IBOutlet weak var faq_answer: UILabel!


    override func awakeFromNib() {
           super.awakeFromNib()
    }

   override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //Farbe auch wenn ausgewählt weis und keinen grauen Hintergrund 
            if selected {
                   contentView.backgroundColor = UIColor.white
            } else {
                   contentView.backgroundColor = UIColor.white
             }
   }
   
}


