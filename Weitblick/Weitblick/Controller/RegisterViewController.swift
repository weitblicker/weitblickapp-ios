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

        // Do any additional setup after loading the view.
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
    
    
           // 11
           func textFieldShouldReturn(textField: UITextField) -> Bool {
                
               self.view.endEditing(true)
                
               return true
            
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
