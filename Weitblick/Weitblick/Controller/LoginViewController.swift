//
//  LoginViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //emailField.text=""
        //spasswordField.text=""
    }
    
 
    
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBAction func LoginButton(_ sender: UIButton) {
        
        if(self.email.text == ""){
            
            let alertView = UIAlertController(title: "Achtung!", message: "Email-Feld darf nicht leer sein", preferredStyle: UIAlertController.Style.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
            
            
        }else if (self.password.text == ""){
            
            let alertView = UIAlertController(title: "Achtung!", message: "Password-Feld darf nicht leer sein",preferredStyle: UIAlertController.Style.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
            
        }else {
            
            //hier User einloggen
            
        }
        
        
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func newPassword(_ sender: UIButton) {
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
    }
    
   
   
}
