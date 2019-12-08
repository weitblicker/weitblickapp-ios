//
//  ForgottPasswordViewController.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 08.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit


class ForgottPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
           tap.cancelsTouchesInView = false
         view.addGestureRecognizer(tap)


        //view verschieben bei tastatur
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var email: UITextField!
    @IBAction func forgottPassword(_ sender: Any) {
        
        if(self.email.text!.isEmpty){
                  showErrorMessage(message: "E-Mail Feld darf nicht leer sein")
              }
              
        UserService.resetPassword(email: self.email.text!) { (response) in
            if(response == "successful" ){
                
               DispatchQueue.main.async {
                self.showAlertMess(userMessage: "Passwort wurde erfolgreich geändert")
                }
                
            }else{
                DispatchQueue.main.async {
                     self.showErrorMessage(message: "Es sind Probleme beim Ändern des Passwort aufgetreten. Bitte versuchen Sie es in Kürze nochmal!")
                }
               
            }
        }
      
    }
    
    func showAlertMess(userMessage: String){

              let alertView = UIAlertController(title: "Achtung!", message: userMessage, preferredStyle: UIAlertController.Style.alert)
              alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

              self.present(alertView, animated: true, completion: nil)

          }
    
    
    func showErrorMessage(message:String) {
          let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
          let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
          }
          alertView.addAction(OKAction)
          self.present(alertView, animated: true, completion:nil)
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

}
