//
//  PaListCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 29.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//


//Hauptzelle für Partner auf ProjectDetailController 
import Foundation
import  UIKit

class PaListCell: UITableViewCell {
    
    @IBOutlet weak var palist_image: UIImageView!
    
    @IBOutlet weak var palist_name: UILabel!
    
    @IBOutlet weak var palist_description: UILabel!

    override func awakeFromNib() {
            super.awakeFromNib()
    }


}
