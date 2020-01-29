//
//  P_DetailFahrradCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 29.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class P_DetailFahrradCell: UITableViewCell {
    
    @IBOutlet weak var spendenstand: UILabel!
    
    @IBOutlet weak var radfahrer_anzahl: UILabel!
    @IBOutlet weak var fahrrad_chart: UILabel!
    @IBOutlet weak var spendenziel: UILabel!
    @IBOutlet weak var gefahren: UILabel!
    
    @IBOutlet weak var fahrrad_button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
