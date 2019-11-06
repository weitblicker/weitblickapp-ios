//
//  NewsTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 04.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit
class NewsTableViewCell: UITableViewCell {
    
  
    
    @IBOutlet weak var news_description: UILabel!
    
    @IBOutlet weak var news_place: UILabel!
    @IBOutlet weak var news_img: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
