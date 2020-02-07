//
//  P_DetailSpendenCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 29.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import Foundation

import  UIKit

class P_DetailSpendenCell: UITableViewCell {
    
    
   
    @IBOutlet weak var spendenzielName: UILabel!
    @IBOutlet weak var spendenkonto: UILabel!
    @IBOutlet weak var spendenstand: UILabel!
    
    @IBOutlet weak var spendenziel: UILabel!
    
    @IBOutlet weak var spenden_star_img: UIImageView!
    
    @IBOutlet weak var spendenbeschreibung: UILabel!
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }


}
