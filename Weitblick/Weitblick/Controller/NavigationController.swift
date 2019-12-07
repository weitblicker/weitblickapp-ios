//
//  NavigationController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 03.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import Foundation

class NavigationController: UINavigationController {
    
    var image = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
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

extension UIViewController {
    func setNavigationItem() {
        let imageView = UIImageView(image: UIImage(named: "Weitblick"))
        let item = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItem = item
    }
}
