//
//  ProjectTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 09.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

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
         // Initialization code
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         // Configure the view for the selected state
        if selected {
                contentView.backgroundColor = UIColor.white
            } else {
                contentView.backgroundColor = UIColor.white
            }
     }
   
    
  
   
 
    
    

}
