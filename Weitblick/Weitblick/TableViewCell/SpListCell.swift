//
//  SpListCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 29.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//


//Hauptzelle für Sponsoren auf ProjectDetailController 

import Foundation
import UIKit


class SpListCell: UITableViewCell {
    
    @IBOutlet weak var splist_sponsor: UILabel!
    @IBOutlet weak var splist_image: UIImageView!
    @IBOutlet weak var splist_description: UILabel!
    
    override func awakeFromNib() {
       super.awakeFromNib()
    }


}
