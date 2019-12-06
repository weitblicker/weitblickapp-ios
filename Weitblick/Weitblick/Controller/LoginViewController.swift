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
    }

 @objc func dismissKeyboard() {
     //Causes the view (or one of its embedded text fields) to resign the first responder status.
     view.endEditing(true)
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
       /* let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
        urlRequest.httpBody = jsonUser*/
    //    let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
       /*     do{
              let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
              request.httpBody = jsonUser
                print(jsonUser)
                if let parseJSON = jsonUser {

                    let accessToken = parseJSON["key"] as? String
                    print("ACCESSTOKEN=====")
                    print(accessToken)
                    //let userId = parseJSON["id"] as? String
                    //Token abspeichern

                     let saveAccesssToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                     //let saveUserId: Bool = KeychainWrapper.standard.set(userId!, forKey: "userId")
                    print("Acces token true or false: \(saveAccesssToken)")
                    print(accessToken)
                    //print("Userid token true or false: \(saveUserId)")

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
        task.resume()*/
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
                        
                        let accessToken = received["key"] as? String
                        print("ACCESSTOKEN=====")
                        print(accessToken)
                        let saveAccesssToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                         //let saveUserId: Bool = KeychainWrapper.standard.set(userId!, forKey: "userId")
                        print("Acces token true or false: \(saveAccesssToken)")
                        print(accessToken)
                        //print("Userid token true or false: \(saveUserId)")

                        if (accessToken!.isEmpty){
                           self.showAlertMess(userMessage: "Could not successfully perform this request. Please try again later")
                            return
                        }
                        
                        print("The Recieved Message is: " + received.description)
                        print (received.description)
                       if received.values.count != 0
                                          {
                                           DispatchQueue.main.async {

                                               self.showErrorMess(message: received.description)
                                               return
                                                             }
                                          }

                        guard let userID = received["id"] as? Int else {
                          print("Could not get User as int from JSON")
                          return
                        }
                        print("The ID is: \(userID)")
                      }catch{
                        print("error parsing response from POST on /user")
                        return
                      }
                    }
                    task.resume()

    }
    
    func showErrorMess(message: String){
      let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
      /*  if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }*/
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
