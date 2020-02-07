//
//  BlListCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 29.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class BlListCell: UITableViewCell {
    
    @IBOutlet weak var bllist_location: UILabel!
    
    @IBOutlet weak var bllist_date: UILabel!
    
    @IBOutlet weak var bllist_title: UILabel!
    
    @IBOutlet weak var bllist_image: UIImageView!
    @IBOutlet weak var bllist_description: UILabel!
    
    @IBOutlet weak var bllist_author: UILabel!
    
    @IBOutlet weak var bllist_profileimg: UIImageView!
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }


}
