//
//  MeList.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 29.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.

//Hauptzelle für Meilensteine auf ProjectDetailController 
import Foundation
import UIKit


class MeListCell: UITableViewCell {
    
    
    @IBOutlet weak var melist_headline: UILabel!
    @IBOutlet weak var melist_date: UILabel!
    @IBOutlet weak var melist_image: UIImageView!
    @IBOutlet weak var melist_description: UILabel!
  
    override func awakeFromNib() {
            super.awakeFromNib()
    }


}
