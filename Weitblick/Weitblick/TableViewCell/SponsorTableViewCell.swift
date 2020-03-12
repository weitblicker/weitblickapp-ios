//
//  SponsorTableViewCell.swift
//  Weitblick
//
//  Created by Jana  on 28.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//


//Zelle für Sponsoren auf ResulMapViewController 
import UIKit

class SponsorTableViewCell: UITableViewCell {

     @IBOutlet weak var name: UILabel!
     @IBOutlet weak var spon_image: UIImageView!

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


