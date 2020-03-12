//
//  EvListCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 29.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

//Hauptzelle für Events auf ProjectDetailController 
import Foundation
import UIKit


class EvListCell: UITableViewCell {
    
    @IBOutlet weak var evlist_date: UILabel!
    @IBOutlet weak var evlist_time: UILabel!
    @IBOutlet weak var evlist_location: UILabel!
    @IBOutlet weak var evlist_title: UILabel!
    @IBOutlet weak var evlist_description: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
    }


}
