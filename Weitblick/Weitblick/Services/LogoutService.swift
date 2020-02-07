//
//  LogoutService.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 08.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class LogoutService {

  
 static func logout(completion: @escaping (_ response : String) -> ()){
    
    let user = UserDefaults.standard
    var key : String = ""
    key = UserDefaults.standard.string(forKey: "key")!
    user.set(false, forKey: "isLogged")
    user.removeObject(forKey: "key")
    user.synchronize()


    let url = NSURL(string: "https://weitblicker.org/rest/auth/logout/")
    let str = "surfer:hangloose"
    let test2 = Data(str.utf8).base64EncodedString();
    var urlRequest = URLRequest(url:url! as URL as URL)
          urlRequest.httpMethod = "POST"
          urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //  urlRequest.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
    urlRequest.addValue("Token  " + key, forHTTPHeaderField: "Authorization")

     let postString = ["key": key,
        ] as! [String: String]

        do{
        let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
            urlRequest.httpBody = jsonUser
            print("User: ")
            print(jsonUser.html2String)
          }catch {
            print("Error: cannot create JSON from todo")
            completion("Error: cannot create JSON from todo")
            return
          }
          let session = URLSession.shared
          let task = session.dataTask(with: urlRequest){
           (data, response, error) in
           guard error == nil else{
             print("error calling POST on /logout")
             completion("error calling POST on /logout")
            
             print(error!)
            return
           }
           guard let responseData = data else {
             print("Error: did not receive data")
            completion("error calling POST on /logout")
             return
           }

           // parse the result as JSON, since that's what the API provides
           do{
             guard let received = try JSONSerialization.jsonObject(with: responseData,
               options: []) as? [String: Any] else {
                 print("Could not get JSON from responseData as dictionary")
                completion ("Could not get JSON from responseData as dictionary")
                 return
             }

             print("The Recieved Message is: " + received.description)
             completion("successful")


           }catch{
             print("error parsing response from POST on /loggout")
            completion("error parsing response from POST on /loggout")
             return
           }
         }
         task.resume()

    }

}
