//
//  ProjectTableViewCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 08.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class ProjectTableViewCell: UITableViewCell{
  
    @IBOutlet weak var project_image: UIImageView!
    @IBOutlet weak var project_title: UILabel!
    @IBOutlet weak var project_button_bike: UIButton!
    @IBOutlet weak var project_button_detail: UIButton!

    override func awakeFromNib() {
          super.awakeFromNib()
    }

      override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)
      }
}
