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





    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //emailField.text=""
        //spasswordField.text=""

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
      /*  let userEmailStored = UserDefaults.standard.string(forKey: "userEmail")
        let userPasswordStored = UserDefaults.standard.string(forKey: "userPassword")
        if(userEmailStored == self.email.text){
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            print("User loggedIn")

        }*/



        let url = NSURL(string: "https://new.weitblicker.org/rest/auth/login/")
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url : (url as URL?)!,cachePolicy:URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
                    // urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let postString = ["email": self.email.text!, "password": self.password.text!] as [String: String]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }catch let error{
            print(error.localizedDescription)
            showAlertMess(userMessage: "Irgendwas ist nicht richtig beim Login")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

        do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {

                    if parseJSON["errorMessageKey"] != nil
                    {
                         self.showAlertMess(userMessage: parseJSON["errorMessage"] as! String)
                        return
                    }

                    let accessToken = parseJSON["token"] as? String
                    let userId = parseJSON["id"] as? String
                    //Token abspeichern

                     let saveAccesssToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                     let saveUserId: Bool = KeychainWrapper.standard.set(userId!, forKey: "userId")
                    print("Acces token true or false: \(saveAccesssToken)")
                    print("Userid token true or false: \(saveUserId)")

                    if (accessToken!.isEmpty){
                       self.showAlertMess(userMessage: "Could not successfully perform this request. Please try again later")
                        return
                    }

                    DispatchQueue.main.async {
                            let startPage = self.storyboard?.instantiateViewController(withIdentifier: "NewsEventViewController") as! NewsEventViewController
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window??.rootViewController = startPage
                    }

                }else{

                    self.showAlertMess(userMessage: "Der Request konnte nicht verarbeitet werden. Bitte versuchen Sie es erneut")
                }

            }catch{
                self.showAlertMess(userMessage: "Could not successfully perform this request. Please try again later")
                print(error)
            }

         }
        task.resume()

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
