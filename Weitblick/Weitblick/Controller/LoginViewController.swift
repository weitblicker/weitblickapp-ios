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
        
        if(self.email.text!.isEmpty){
            showAlertMess(userMessage: "Email-Feld darf nicht leer sein")
            return;
        }
        if (self.password.text!.isEmpty){
            
            showAlertMess(userMessage: "Passwort-Feld darf nicht leer sein")
                       return;
            
        }
            
            //hier User einloggen
        let userEmailStored = UserDefaults.standard.string(forKey: "userEmail")
        let userPasswordStored = UserDefaults.standard.string(forKey: "userPassword")
        if(userEmailStored == self.email.text){
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            print("User loggedIn")
            
        }
            
        
        
        
        
    }
    
    func showAlertMess(userMessage: String){
           let alertView = UIAlertController(title: "Achtung!", message: userMessage, preferredStyle: UIAlertController.Style.alert)
           alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

           self.present(alertView, animated: true, completion: nil)
           
       }
    
    @IBAction func newPassword(_ sender: UIButton) {
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
    }
    

}
