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

        // Login Request
        let url = NSURL(string: "https://new.weitblicker.org/rest/auth/login/")
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
       // var request = URLRequest(url : (url as URL?)!,cachePolicy:URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        var request = URLRequest(url:url! as URL as URL)
        request.httpMethod = "POST"
       request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
      //  request.addValue("application/json", forHTTPHeaderField: "Accept")
      
       let user = UserDefaults.standard
        let postString = ["username": "","email": self.email.text!, "password": self.password.text!] as [String: String]


        do{
        let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
            
            request.httpBody = jsonUser
            print("User: ")
            print(jsonUser.html2String)
          }catch {
            print("Error: cannot create JSON from todo")
            return
          }
          let session = URLSession.shared
          let task = session.dataTask(with: request){
        
           (data, response, error) in
           guard error == nil else{
             print("error calling POST in Login")
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
            
             guard let userKey = received["key"] as? String else {
                             user.set(false, forKey: "isLogged")
                           //  UserDefaults.standard.synchronize()
                              DispatchQueue.main.async {
                              self.showErrorMessage(message: received.description)
                               user.set(false, forKey: "isLogged")
                                UserDefaults.standard.synchronize()
                 
                                            }
                             return
                           }

            
            print("TOKEN: ")
            print (userKey)
            
            user.set(userKey, forKey: "key")
            user.set(true, forKey: "isLogged")
            user.synchronize()
            //Token abspeichern
            let saveAccesssToken: Bool = KeychainWrapper.standard.set(userKey, forKey: "Key")
            // let saveUserId: Bool = KeychainWrapper.standard.set(userId!, forKey: "userId")
            print("Acces token true or false: \(saveAccesssToken)")
            print("Username")
            print(user.object(forKey: "username") as Any)
            print("The Key is: \(userKey)")
  

           }catch{
             print("error parsing response from POST on /user")
             return
           }
         }
        
        let login = UserDefaults.standard.bool(forKey: "isLogged")
                   
                if(login == true){
                   //Auf news View umleiten
                   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                   let bikeViewController = storyBoard.instantiateViewController(withIdentifier: "BikeViewController") as! BikeViewController
                 // self.present(newsViewController, animated: true, completion: nil)
                  //  tabBarController!.present(newsViewController, animated: true)
                //    DispatchQueue.main.async {
                    /*    if let navigator = self.navigationController {
                                navigator.pushViewController(newsViewController, animated: true)
                           // }
                                 }
                    }*/
                    self.reloadInputViews()
                    DispatchQueue.main.async {
             //       self.performSegue(withIdentifier: "goToMap", sender: self)
                      
                    }
        }
        
         task.resume()
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              if segue.destination is NewsViewController
              {
                  let newsViewController = segue.destination as? NewsViewController
                 //self.reloadInputViews()
                 
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



    @IBAction func registerButton(_ sender: UIButton) {
    }


    @IBAction func closeName(_ sender: UITextField) {
        self.view.endEditing(true)
    }

}
