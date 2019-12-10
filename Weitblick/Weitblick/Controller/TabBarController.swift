//
//  TabBarController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import SwipeableTabBarController


class TabBarController: SwipeableTabBarController,UINavigationControllerDelegate {

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
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }

    public func loadNavImages(){
        let image = UIImage(named : "Weitblick")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 170, height: 45)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 60))
        titleView.addSubview(imageView)
        titleView.backgroundColor = .clear
        self.navigationItem.titleView = titleView
        let rightBarButton = UIBarButtonItem(title: "Profil", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TabBarController.goToProfile(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton

    }



  

    
}
