//
//  NewsTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 09.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

//Zelle für Newsliste auf NewsController 
import Foundation
import  UIKit

class NewsTableViewCell : UITableViewCell{
  
    @IBOutlet weak var news_image: UIImageView!
    @IBOutlet weak var news_date: UILabel!
    @IBOutlet weak var news_description: UILabel!
    @IBOutlet weak var formlabel: UILabel!
    @IBOutlet weak var news_title: UILabel!
    @IBOutlet weak var news_button_detail: UIButton!
    @IBOutlet weak var news_location: UILabel!
    @IBOutlet weak var news_hostLbl: UILabel!
    @IBOutlet weak var triangle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //Hintergrundfarbe anpassen 
        if selected {
            contentView.backgroundColor = UIColor.white
        } else {
            contentView.backgroundColor = UIColor.white
        }
    }
 }

