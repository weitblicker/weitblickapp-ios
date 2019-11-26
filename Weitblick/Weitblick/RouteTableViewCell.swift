//
//  RouteTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 26.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class RouteTableViewCell: UITableViewCell{
    
    
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var donation: UILabel!
    @IBOutlet weak var route: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
     }
    
}
