//
//  ProjectTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 09.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

//Zelle für Liste von Projekten auf ProjectController 

import Foundation
import UIKit

class ProjectTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var project_image: UIImageView!
    @IBOutlet weak var project_location: UILabel!
    @IBOutlet weak var project_title: UILabel!
    @IBOutlet weak var project_city: UILabel!
    @IBOutlet weak var triangle: UILabel!
    @IBOutlet weak var project_button_bike: UIButton!
    @IBOutlet weak var project_button_detail: UIButton!
    
    override func awakeFromNib() {
         super.awakeFromNib()
    }

     override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
          //Hintergrundfarbe der Zelle immer weis, auch wenn ausgewählt
        if selected {
            contentView.backgroundColor = UIColor.white
        } else {
            contentView.backgroundColor = UIColor.white
        }
     }

}
