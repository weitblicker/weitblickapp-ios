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
    
    
    @IBOutlet weak var password_old: UITextField!
    @IBOutlet weak var password_new: UITextField!
    @IBOutlet weak var password_new2: UITextField!
    override func viewDidLoad() {
    super.viewDidLoad()
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
                  tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
        
        //view verschieben bei tastatur
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
              
           }
           
        @objc func dismissKeyboard() {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }
    //view verschieben wenn tastaur erscheint
       @objc func keyboardWillShow(sender: NSNotification) {
            self.view.frame.origin.y = -150 // Move view 150 points upward
       }

       @objc func keyboardWillHide(sender: NSNotification) {
            self.view.frame.origin.y = 0 // Move view to original position
       }
    
    @IBAction func button_change_password(_ sender: Any) {
        
        let message:String = "Dein Passwort wurde erfolgreich geändert"
        
    
        if (self.password_old.text!.isEmpty || self.password_new.text!.isEmpty || self.password_new2.text!.isEmpty){
                  showErrorMessage(message: "Passwort-Feld darf nicht leer sein")
                             return;

              }
        
        if(self.password_new.text != self.password_new2.text){
            showErrorMessage(message: "Passwort-Felder stimmen nicht überein")
            return;
        }
        
        UserService.changePassword(password_old: self.password_old.text!, password_new: self.password_new.text!, password_new2: self.password_new2.text!){ (response) in
            
            if (response != ""){
                DispatchQueue.main.async {
                     self.showAlertMess(userMessage: response)
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

    
}
