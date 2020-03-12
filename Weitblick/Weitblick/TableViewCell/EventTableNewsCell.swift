//
//  EventTableNewsCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 09.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

//Zelle für Tabelle Liste von Events auf EventController 

import Foundation
import UIKit


class EventTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var event_host: UILabel!
    @IBOutlet weak var event_description: UILabel!
    @IBOutlet weak var event_location: UILabel!
    @IBOutlet weak var event_date: UILabel!
    @IBOutlet weak var event_image: UIImageView!
    @IBOutlet weak var event_button: UIButton!

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


