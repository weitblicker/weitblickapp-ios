//
//  RegisterViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
                  tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)

       
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBOutlet weak var email: UITextField!
    
    
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var password2: UITextField!
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        if (self.email.text == ""){
            let alertView = UIAlertController(title: "Achtung!", message: "Email-Feld darf nicht leer sein", preferredStyle: UIAlertController.Style.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alertView, animated: true, completion: nil)
        }else if (self.password.text == ""){
            let alertView = UIAlertController(title: "Achtung!", message: "Passwot-Feld darf nicht leer sein", preferredStyle: UIAlertController.Style.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alertView, animated: true, completion: nil)
            
        }else if (self.password2.text == ""){
            let alertView = UIAlertController(title: "Achtung!", message: "Password wiederholen- Feld darf nicht leer sein", preferredStyle: UIAlertController.Style.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alertView, animated: true, completion: nil)
            
        }
        
        else if (self.password2.text != self.password.text){
            let alertView = UIAlertController(title: "Achtung!", message: "Passwörter sind nicht gleich", preferredStyle: UIAlertController.Style.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alertView, animated: true, completion: nil)
        }else{
            //POST-Request zum Registrieren des Users
            
        }
        
    }
    
    
    
    @IBAction func InfoButton(_ sender: UIButton) {
        let message:String = "Der Username wird öffentlich sichtbar sein"
   
                       let alertController:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)

                       let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
                       alertController.addAction(alertAction)
                       present(alertController, animated: true, completion: nil)
    }
    
    
         
    @IBAction func textFieldShouldReturn(_ sender: UITextField) {
        self.view.endEditing(true)
                       
                      
    }
    
    @IBAction func passwortWiederholenClose(_ sender: UITextField) {
          self.view.endEditing(true)
    }
    
    @IBAction func mailClose(_ sender: UITextField) {
         self.view.endEditing(true)
    }
    
    @IBAction func usernameClose(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    
   
  

}
