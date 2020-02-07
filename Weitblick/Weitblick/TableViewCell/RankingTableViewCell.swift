//
//  RankingTableViewCell.swift
//  Weitblick
//
//  Created by Jana  on 12.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var number: UILabel!
    
    
    @IBOutlet weak var pimage: UIImageView!
    
   
    
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
