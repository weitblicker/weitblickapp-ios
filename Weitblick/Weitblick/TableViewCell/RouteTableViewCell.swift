//
//  RouteTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 26.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//


//Zelle für die Tabelle der eigenen bisher gefahrenen Strecken 
import Foundation
import UIKit

class RouteTableViewCell: UITableViewCell{
    
    
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var donation: UILabel!
    @IBOutlet weak var route: UILabel!
    @IBOutlet weak var date: UILabel!
    
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
    

