//
//  NavigationBar.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 11.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationController {

    override func draw(_ rect: CGRect) {
       let image = UIImage(named : "Weitblick")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 170, height: 45)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 60))
        titleView.addSubview(imageView)
        titleView.backgroundColor = .clear
        self.titleView = titleView
        let rightBarButton = UIBarButtonItem(title: "Profil", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TabBarController.goToProfile(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }


}
