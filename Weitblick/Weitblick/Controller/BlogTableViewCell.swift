//
//  BlogTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 14.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import  UIKit


class BlogTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var blog_image: UIImageView!
    
    @IBOutlet weak var blog_date: UILabel!
    
    @IBOutlet weak var blog_description: UILabel!
    
    
    
    override func awakeFromNib() {
           super.awakeFromNib()

       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

        
       }
    
    
}
