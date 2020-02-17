//
//  NeListCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 29.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit


class NeListCell: UITableViewCell {
    
    
    @IBOutlet weak var nelist_image: UIImageView!
    
    @IBOutlet weak var nelist_profileimg: UIImageView!
    
    @IBOutlet weak var nelist_location: UILabel!
    
    @IBOutlet weak var nelist_title: UILabel!
    
    @IBOutlet weak var nelist_author: UILabel!
    
    @IBOutlet weak var nelist_description: UILabel!
    
    @IBOutlet weak var nelist_date: UILabel!
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }


}
