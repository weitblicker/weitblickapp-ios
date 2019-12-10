//
//  RegisterService.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 09.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RegisterService {

    static func registerWithData(username: String, email : String, password1: String, password2: String, completion: @escaping (_ responseString : String) -> ()){
        

          let url = NSURL(string: "https://new.weitblicker.org/rest/auth/registration/")
          let str = "surfer:hangloose"
          let test2 = Data(str.utf8).base64EncodedString();
         // var urlRequest = URLRequest(url : (url as URL?)!,cachePolicy:URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
              var urlRequest = URLRequest(url:url! as URL as URL)
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")

                //urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

           let postString = ["username": username,
                             "email": email,
                            "password1": password1,
                            "password2": password2,
                            ] as [String: String]

          let user = UserDefaults.standard
          

              do{
                  let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
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

                 guard let userKey = received["key"] as? String else {
                     user.set(false, forKey: "isRegisterd")
                    completion(received.description)
                      return
                                   }
                  
                    completion(received.description)
                        //Alle User Daten speichern
                       // user.set(userKey, forKey: "key")
                        user.set(true, forKey: "isRegisterd")
                       UserDefaults.standard.synchronize()

                 }catch{
                   print("error parsing response from POST on /user")
                   return
                 }
               }


          task.resume()



        
        
    }
  

}
