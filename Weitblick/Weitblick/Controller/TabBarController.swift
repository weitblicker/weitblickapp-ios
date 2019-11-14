//
//  TabBarController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class TabBarController: SwipeableTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.sideBySide
    }
    override func viewWillAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        let imageView = UIImageView(frame : CGRect(x : 0 , y : 0, width : 40 , height : 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named : "Weitblick")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
}
