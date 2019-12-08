//
//  LoginViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        //View verschieben bei tastatur
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    //view verschieben wenn tastatur erscheint
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }

    @IBAction func LoginButton(_ sender: UIButton) {
        if(self.email.text!.isEmpty){
            showAlertMess(userMessage: "Email-Feld darf nicht leer sein")
            return;
        }
        if (self.password.text!.isEmpty){
            showAlertMess(userMessage: "Passwort-Feld darf nicht leer sein")
            return;
        }
            LoginService.loginWithData(email: self.email.text!, password: self.password.text!) { (response) in
                if(UserDefaults.standard.bool(forKey: "isLogged")){
                    DispatchQueue.main.async {
                        self.reloadInputViews()
                        self.dismiss(animated: true, completion: nil)
                    }
                }else{
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: response)
                    }
                }
            }
    }
        
      func showErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        self.present(alertView, animated: true, completion:nil)
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


    @IBAction func closeName(_ sender: UITextField) {
        self.view.endEditing(true)
    }

}
