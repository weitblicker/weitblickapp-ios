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
            
            let userKey  = received["key"] as? String
           /* let user = UserDefaults.standard
            user.set(userKey, forKey: "key")*/
            if (userKey == nil){
               DispatchQueue.main.async {
               self.showErrorMessage(message: received.description)
               return
                             }
            }
            print("TOKEN: ")
            print (userKey)
            //Token abspeichern
             let saveAccesssToken: Bool = KeychainWrapper.standard.set(userKey!, forKey: "Key")
            // let saveUserId: Bool = KeychainWrapper.standard.set(userId!, forKey: "userId")
            print("Acces token true or false: \(saveAccesssToken)")
            
           }catch{
             print("error parsing response from POST on /user")
             return
           }
         }
         task.resume()
  
    }
    func  showErrorMessage(message:String) {
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
    
  
    
    

}
