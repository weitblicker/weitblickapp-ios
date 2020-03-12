//
//  RegisterViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet var popover: UIScrollView!
    @IBAction func go(){
    }
    
    @IBAction func backToRegister(_ sender: Any) {
        self.popover.removeFromSuperview()
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        //View verschieben bei Tastatur
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
       }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


    //View verschieben wenn tastaur erscheint
       @objc func keyboardWillShow(sender: NSNotification) {
            self.view.frame.origin.y = -230 // Move view 150 points upward
       }

       @objc func keyboardWillHide(sender: NSNotification) {
            self.view.frame.origin.y = 0 // Move view to original position
       }

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var errorText: UILabel!
    var clicked = 0
    
    //Checkbox image festlegen
    func setUpButton(){
           checkbox.addTarget(self, action: Selector(("chechbox:")), for : UIControl.Event.touchUpInside)
       }
    
    //Bei ausgewählter Checkbox Bild ändern
    @IBAction func checkbox(_ sender: Any) {
        if(clicked == 0){
        let image = UIImage(named:  "checkbox_full.png")
            (sender as AnyObject).setImage(image, for: UIControl.State.normal)
            clicked = 1
            return
        } else if(clicked==1){
            let image = UIImage(named: "checkbox_empty.png")
            (sender as AnyObject).setImage(image, for: UIControl.State.normal)
            clicked = 0
        }
    }
    
    //Prüfen ob alle Felder ausgewählt und ausfegfüllt
    //Falls ja RegisterService aufrufen und User registriere
    //Bei erfolgreicher Registrierung LoginView anzeigen lassen
    @IBAction func registerButton(_ sender: UIButton) {
        if(clicked == 0 ){
            showAlertMess(userMessage: "Bitte AGB bestätigen");
            return;
        }
        if (self.username.text!.isEmpty){
                   showAlertMess(userMessage: "Username-Feld darf nicht leer sein")
                   return;
        }
        if (self.email.text!.isEmpty){
            showAlertMess(userMessage: "Email-Feld darf nicht leer sein")
            return
        }
        if (self.password.text!.isEmpty){
            showAlertMess(userMessage: "Passwort-Feld darf nicht leer sein")
             return;
        }
        if (self.password2.text!.isEmpty){
            showAlertMess(userMessage: "Passwort wiederholen- Feld darf nicht leer sein")
             return;
        }
        if (self.password.text != self.password2.text){
            showAlertMess(userMessage: "Passwörter sind nicht gleich!")
             return;
        }
        
        RegisterService.registerWithData(username: self.username.text!,email: self.email.text!, password1: self.password.text!, password2: self.password2.text!) { (response) in
        
          if(response != "" ){
                DispatchQueue.main.async {
                    self.showAlertMess(userMessage: response)
                    let register = UserDefaults.standard.bool(forKey: "isRegisterd")
                    if(register == true){
                        DispatchQueue.main.async {
                            self.reloadInputViews()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
            }
            }
        }
    }

    //Warnung-Nachrichten ausgeben
    func showAlertMess(userMessage: String){
        let alertView = UIAlertController(title: "Achtung!", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    //Error-Nachrichten ausgeben
    func  showErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        self.present(alertView, animated: true, completion:nil)
    }
    //Infobutton auf Registerpage anzeigen lassen
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
