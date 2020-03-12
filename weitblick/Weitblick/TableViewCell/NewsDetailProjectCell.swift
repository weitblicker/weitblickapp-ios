//
//  NewsDetailProjectCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 06.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//


//Projektzelle auf NewsDetailController 
import Foundation
import UIKit


class NewsDetailProjectCell: UITableViewCell{
   
    @IBOutlet weak var project_image: UIImageView!
    @IBOutlet weak var project_partner: UILabel!
    @IBOutlet weak var project_location: UILabel!
    @IBOutlet weak var project_title: UILabel!
    @IBOutlet weak var project_ride_button: UIButton!
    
    override func awakeFromNib() {
       super.awakeFromNib()
    }
    
}
