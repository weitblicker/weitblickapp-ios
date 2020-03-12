//
//  ProjectCycleCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 06.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//


//Zelle für Projektübersicht für die man Fahrrad fahren kann, Tabelle die bei Mapview erscheint wenn man auf
//den Projektnamen klickt für das man gerade Fahhrad fährt
import Foundation
import UIKit

class ProjectCycleCell: UITableViewCell{
 
    @IBOutlet weak var project_image: UIImageView!
    @IBOutlet weak var project_partner: UILabel!
    @IBOutlet weak var project_title: UILabel!
    @IBOutlet weak var project_location: UILabel!
    @IBOutlet weak var project_cycle_button: UIButton!
    
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
