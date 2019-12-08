//
//  ProfileViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

extension UIPageViewController {

    func goToNextPage(){

        guard let currentViewController = self.viewControllers?.first else { return }

        guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }

        setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)

    }
    
    func goToPreviousPage(){

        guard let currentViewController = self.viewControllers?.first else { return }

        guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }

        setViewControllers([previousViewController], direction: .reverse, animated: false, completion: nil)

    }
}


extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true


    }
}

class ProfileViewController:  UIViewController {


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


    @IBAction func logOut(_ sender: Any) {
        

        LogoutService.logout() { (response) in
                   if(response == "successful" ){ 
                      DispatchQueue.main.async {
                      //switch page
                        
                        
                       }
                       
                   }else{
                       DispatchQueue.main.async {
                            self.showErrorMessage(message: "Es sind Probleme beim Logout aufgetreten. Bitte versuchen Sie es in Kürze nochmal!")
                       }
                      
                   }
               }
        
        
    }

    func  showErrorMessage(message:String) {
           let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
           let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
           }
           alertView.addAction(OKAction)
           self.present(alertView, animated: true, completion:nil)
       }
    
    


}
