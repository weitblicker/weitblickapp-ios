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

        //view verschieben bei tastatur
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    //view verschieben wenn tastaur erscheint
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


    @IBAction func registerButton(_ sender: UIButton) {
        if (self.username.text!.isEmpty){
                   showAlertMess(userMessage: "Username-Feld darf nicht leer sein")
                   return;

               }

        if (self.email.text!.isEmpty){
            showAlertMess(userMessage: "Email-Feld darf nicht leer sein")
            return;

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
            //POST-Request zum Registrieren des Users

        //Store Data
    /*    UserDefaults.standard.set(self.email.text, forKey:"userEmail")
        UserDefaults.standard.set(self.password.text, forKey:"userPassword")
        UserDefaults.standard.synchronize()

            let alertView = UIAlertController(title: "Achtung!", message: "Registrierung erfolgreich. Vielen Dank!", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){
                action in
                self.dismiss(animated: true,completion:nil)
            }
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alertView, animated: true, completion: nil)
            print("User registriert")*/


        //POST-Request zum Registrieren des Users


        let url = NSURL(string: "https://new.weitblicker.org/rest/auth/registration/")
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var urlRequest = URLRequest(url : (url as URL?)!,cachePolicy:URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
              urlRequest.httpMethod = "POST"
              urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
              urlRequest.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
             // urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

         let postString = ["username": self.username.text!,
                           "email": self.email.text!,
                          "password1": self.password.text!,
                          "password2": self.password2.text!,
                          ] as [String: String]

            do{
            let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
                urlRequest.httpBody = jsonUser
                print("User: ")
                print(jsonUser.html2String)
              }catch {
                print("Error: cannot create JSON from todo")
                return
              }
              let session = URLSession.shared
              let task = session.dataTask(with: urlRequest){
               (data, response, error) in
               guard error == nil else{
                 print("error calling POST on /user/1")
                 print(error!)
                return
               }
               guard let responseData = data else {
                 print("Error: did not receive data")
                 return
               }

               // parse the result as JSON, since that's what the API provides
               do{
                 guard let received = try JSONSerialization.jsonObject(with: responseData,
                   options: []) as? [String: Any] else {
                     print("Could not get JSON from responseData as dictionary")
                     return
                 }

                 print("The Recieved Message is: " + received.description)

                 guard let userKey = received["key"] as? Int else {
                    DispatchQueue.main.async {
                    self.showErrorMessage(message: received.description)

                                  }
                   return
                 }
                let user = UserDefaults.standard
                user.set(userKey, forKey: "key")
                user.set(self.username.text, forKey: "name")
                user.set(self.email.text, forKey: "email")
                user.set(self.password.text, forKey: "password")
                UserDefaults.standard.synchronize()

                 print("The Key is: \(userKey)")
               }catch{
                 print("error parsing response from POST on /user")
                 return
               }
             }
             task.resume()

    }


    func showAlertMess(userMessage: String){
        let alertView = UIAlertController(title: "Achtung!", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        self.present(alertView, animated: true, completion: nil)

    }
    func  showErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        self.present(alertView, animated: true, completion:nil)
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
