//
//  CustomNavigationController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 01.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class CustomNavigationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let color = UIColor(red: 81 / 255, green: 155 / 255, blue: 22 / 255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = color

        let image = UIImage(named: "Weitblick")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    private func imageView(imageName: String) -> UIImageView {
        let logo = UIImage(named: imageName)
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = logo
        logoImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return logoImageView
    }

    func barImageView(imageName: String) -> UIBarButtonItem {
        return UIBarButtonItem(customView: imageView(imageName: imageName))
    }

    func barButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
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
