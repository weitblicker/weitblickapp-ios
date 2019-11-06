//
//  ProjectTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 04.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit
class ProjectTableViewCell: UITableViewCell {
    
  
    
 
    @IBOutlet weak var project_img: UIImageView!
    
    @IBOutlet weak var project_place: UILabel!
    
    @IBOutlet weak var project_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
