//
//  LoginService.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 08.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginService{

    static func loginWithData(email : String, password : String, completion: @escaping (_ responseString : String) -> ()){
        print("In LoginWithData")
//        var key : String = ""
//        key = UserDefaults.standard.string(forKey: "key")!
        let url = NSURL(string: Constants.loginURL)
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url:url! as URL)
       //var request = URLRequest(url : (url as URL?)!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")



        let user = UserDefaults.standard
        let postString = ["username": "","email": email, "password": password] as [String: String]
        do{
            let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
            request.httpBody = jsonUser
        }catch {
            print("Error: cannot create JSON from todo")
            return
        }
        print("In LoginWithData vor Task")
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            print("In LoginWithData in Task")
            guard error == nil else{
               print("error calling POST in Login")
               print(error!)
               return
            }
            guard let responseData = data else {
               print("Error: did not receive data")
               return
            }
            do{
                 guard let received = try JSONSerialization.jsonObject(with: responseData,
                              options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                print("RECEIVED")
                print(received)
            //print("The Recieved Message is: " + received.description)

               /* let names = userData.value(forKeyPath: "data.username")
                if !names.isEmpty { print(names[0]) }*/

                guard let userKey = received["key"] as? String else {
                    user.set(false, forKey: "isLogged")
                    //  UserDefaults.standard.synchronize()
                    DispatchQueue.main.async {
                        user.set(false, forKey: "isLogged")
                        UserDefaults.standard.synchronize()
                        //  LoginService.loginWithData(email: self.email.text!, password: self.password.text!) { (response) in
                        self.checkResponse(description: received.description){ (error) in

                             print(error)
                             completion(error)
                        }


                    }
                    return
                }


               print("TOKEN: ")
               print (userKey)
               user.set(userKey, forKey: "key")
               user.set(true, forKey: "isLogged")
               user.set(email, forKey: "email")

                if(user.integer(forKey: "tours") == 0){
                    user.set(1, forKey: "tours")
                }
               user.synchronize()
               //Token abspeichern
               let saveAccesssToken: Bool = KeychainWrapper.standard.set(userKey, forKey: "Key")
                completion("Successful")
            }catch{
               print("error parsing response from POST on /user")
               return
            }
        }
        task.resume()
    }


 static func checkResponse(description: String, error: @escaping (_ responseString : String) -> ()){

      print("in check Response")

    if (description.contains("Gib eine gültige E-Mail Adresse an.")){
          error("Gib eine gültige E-Mail Adresse an.")
          return
      }
     else if (description.contains("Zugangsdaten stimmen nicht.")){
       error("Die angegebenen Zugangsdaten stimmen nicht.")
          return
      }

  }

}
