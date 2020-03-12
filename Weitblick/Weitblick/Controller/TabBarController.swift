//
//  TabBarController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import SwipeableTabBarController

/*
 =================
 TabBarController:
 =================
    - Root node
    - Setting up navbar
 */

class TabBarController: SwipeableTabBarController,UINavigationControllerDelegate {
    
    var defaultProject : Project?

    override func viewDidLoad() {
        super.viewDidLoad()
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.sideBySide
    }
    override func viewWillAppear(_ animated: Bool) {
        loadNavImages()
        self.navigationController!.navigationBar.topItem!.title = "Zurück"
    }

    @objc func goToProfile(_ sender:UIBarButtonItem!){
        
        if(!UserDefaults.standard.bool(forKey: "isLogged")){
            self.performSegue(withIdentifier: "checkLogin", sender: self)
        }else{
            self.performSegue(withIdentifier: "showProfile", sender: self)
        }
    }

    public func loadNavImages(){
        let image = UIImage(named : "Weitblick")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 170, height: 45)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 60))
        titleView.addSubview(imageView)
        titleView.tintColor = UIColor.black
        titleView.backgroundColor = .clear
        self.navigationItem.titleView = titleView
        let img = UIImage(named: "profileBlack100")
        let img2 = img?.crop(to: CGSize.init(width: 35, height: 35))
        let rightButton = UIBarButtonItem(image: img2, style: UIBarButtonItem.Style.plain, target: self, action: #selector(TabBarController.goToProfile(_:)))
        rightButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = rightButton

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item == self.tabBar.items![3]){
            if(!UserDefaults.standard.bool(forKey: "isLogged")){
                self.performSegue(withIdentifier: "checkLogin", sender: self)
            }
        }
    }



  

    
}
