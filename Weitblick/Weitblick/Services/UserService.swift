//
//  UserService.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 08.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class UserService{

    static func resetPassword( email: String, completion: @escaping (_ response : String) -> ()){

          // Reset Password Request
          let url = NSURL(string: "https://new.weitblicker.org/rest/auth/password/reset/")
          let str = "surfer:hangloose"
          let test2 = Data(str.utf8).base64EncodedString();
          var request = URLRequest(url:url! as URL as URL)
          request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
         let user = UserDefaults.standard
         let postString = ["email": email] as [String: String]
        
        do{
        let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
            request.httpBody = jsonUser
            print("User: ")
            print(jsonUser.html2String)
          }catch {
            print("Error: cannot create JSON from password/reset")
            completion("Error: cannot create JSON from password/reset")
            return
          }
          let session = URLSession.shared
          let task = session.dataTask(with: request){
           (data, response, error) in
           guard error == nil else{
             print("error calling POST on /password/reset")
             print(error!)
            completion("error calling POST on /password/reset")
            return
           }
           guard let responseData = data else {
             print("Error: did not receive data")
            completion("Error: did not receive data")
             return
           }

           // parse the result as JSON, since that's what the API provides
           do{
             guard let received = try JSONSerialization.jsonObject(with: responseData,
               options: []) as? [String: Any] else {
                 print("Could not get JSON from responseData as dictionary")
                 completion("Could not get JSON from responseData as dictionary")
                 return
             }
             print("The Recieved Message is: " + received.description)
             completion("successful")


           }catch{
             completion("error parsing response from POST on /password/reset")
             print("error parsing response from POST on /password/reset")
             return
           }
         }
         task.resume()
  
    }
    
    
    
    static func changePassword (password_old: String, password_new: String, password_new2: String, completion: @escaping (_ response : String) -> ()){
        
        // Change actual Password Request
         let url = NSURL(string: "https://new.weitblicker.org/rest/auth/password/change/")
         let str = "surfer:hangloose"
         let test2 = Data(str.utf8).base64EncodedString();
         var request = URLRequest(url:url! as URL as URL)
         request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
        let user = UserDefaults.standard
        let postString = ["password_old": password_old, "passsword_new": password_new, "password_new2": password_new2] as [String: String]

        do{
        let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
            request.httpBody = jsonUser
            print("User: ")
            print(jsonUser.html2String)
          }catch {
            print("Error: cannot create JSON from password/change")
            completion("Error: cannot create JSON from password/change")
            return
          }
          let session = URLSession.shared
          let task = session.dataTask(with: request){
           (data, response, error) in
           guard error == nil else{
             print("error calling POST on /password/change")
             print(error!)
            completion("error calling POST on /password/change")
            return
           }
           guard let responseData = data else {
             print("Error: did not receive data")
            completion("Error: did not receive data")
             return
           }

           // parse the result as JSON, since that's what the API provides
           do{
             guard let received = try JSONSerialization.jsonObject(with: responseData,
               options: []) as? [String: Any] else {
                 print("Could not get JSON from responseData as dictionary")
                 completion("Could not get JSON from responseData as dictionary")
                 return
             }
             print("The Recieved Message is: " + received.description)
             completion("successful")


           }catch{
             completion("error parsing response from POST on /password/change")
             print("error parsing response from POST on /password/change")
             return
           }
         }
         task.resume()
           
    }
   

}
