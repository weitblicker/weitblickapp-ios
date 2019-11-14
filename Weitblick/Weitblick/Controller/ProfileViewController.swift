//
//  ProfileViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true

      /* self.layer.cornerRadius = (self.frame.size.width ) / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.black.cgColor*/
    }
}

class ProfileViewController: UIViewController {


    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var profile_email: UILabel!
    @IBOutlet weak var profile_password: UILabel!
    @IBOutlet weak var profile_donation: UILabel!
    @IBOutlet weak var profile_route: UILabel!

    @IBAction func button_edit_password(_ sender: Any) {

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        profile_image.image = UIImage(named: "profile_image")
        profile_image.layer.cornerRadius = profile_image.frame.size.width/2
        profile_image.clipsToBounds = true
        profile_image.layer.borderWidth = 2
        profile_image.layer.borderColor = UIColor.black.cgColor


    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
