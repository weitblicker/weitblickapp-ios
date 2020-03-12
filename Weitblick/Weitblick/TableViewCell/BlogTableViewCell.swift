//
//  BlogTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 14.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

//Zelle für BlogController , Liste von Blogs 

import Foundation
import  UIKit


class BlogTableViewCell: UITableViewCell {
    

    @IBOutlet weak var blog_location_marker: UIImageView!
    @IBOutlet weak var blog_image: UIImageView!
    @IBOutlet weak var blog_date: UILabel!
    @IBOutlet weak var blog_title: UILabel!
    @IBOutlet weak var blog_description: UILabel!
    @IBOutlet weak var blog_button_detail: UIView!
    @IBOutlet weak var blog_city: UILabel!
    @IBOutlet weak var blog_country: UILabel!
    @IBOutlet weak var triangle: UILabel!
    
    
    override func awakeFromNib() {
           super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)
       
        //Hintergrundfarbe der Zelle immer weis nicht grau wenn ausgewählt 
            if selected {
                 contentView.backgroundColor = UIColor.white
             } else {
                   contentView.backgroundColor = UIColor.white
             }
    }

  }
    
    

