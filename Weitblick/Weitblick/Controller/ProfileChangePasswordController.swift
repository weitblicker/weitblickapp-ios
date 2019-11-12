//
//  ProfileChangePasswordController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 12.11.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class ProfileChangePasswordController: UIViewController{
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
    }
    
    
    @IBAction func button_change_password(_ sender: Any) {
        
        let message:String = "Ihr Passwort wurde erfolgreich geändert"
          
          // Get clicked button title label text.
        
          
          // If click button one then display Hello World.
             let alertController:UIAlertController = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
             
             // Create a UIAlertAction object, this object will add a button at alert dialog bottom, the button text is OK, when click it just close the alert dialog.
             let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
             
             // Add alertAction object to alertController.
             alertController.addAction(alertAction)
             // Popup the alert dialog.
             present(alertController, animated: true, completion: nil)
    }

    
}
