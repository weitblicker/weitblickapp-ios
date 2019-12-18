//
//  NavigationController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 11.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
//        self.navigationController!.navigationBar.topItem!.title = "Zurück"
//        let image = UIImage(named : "Weitblick")
//        let imageView = UIImageView(image: image)
//        imageView.frame = CGRect(x: 0, y: 0, width: 170, height: 45)
//        imageView.contentMode = .scaleAspectFit
//        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 60))
//        titleView.addSubview(imageView)
//        titleView.backgroundColor = .clear
//        self.navigationItem.titleView = titleView
//        let rightBarButton = UIBarButtonItem(title: "Profil", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TabBarController.goToProfile(_:)))
//        self.navigationItem.rightBarButtonItem = rightBarButton
    }

    private func setupNavbar(){
        let img = UIImage(named: "Weitblick");
        let titleImageView = UIImageView(image: img)
        titleImageView.frame = CGRect.init(x: 0, y: 0, width: 170, height: 60)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
