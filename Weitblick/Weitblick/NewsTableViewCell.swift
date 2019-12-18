//
//  NewsTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 09.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import  UIKit

class NewsTableViewCell : UITableViewCell{
    
    
    
    @IBOutlet weak var news_image: UIImageView!
    
    @IBOutlet weak var news_date: UILabel!
    
    @IBOutlet weak var news_description: UILabel!
    
    @IBOutlet weak var news_title: UILabel!
    @IBOutlet weak var news_button_detail: UIButton!
    @IBOutlet weak var news_location: UILabel!
    
    
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

