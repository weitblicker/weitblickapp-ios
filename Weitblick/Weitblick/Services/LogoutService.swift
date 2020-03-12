//
//  LogoutService.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 08.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

/*
 ==============
 LogOutService:
 ==============
    - logout - Function
 */

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
        var urlRequest = URLRequest(url:url! as URL as URL)
              urlRequest.httpMethod = "POST"
              urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Token  " + key, forHTTPHeaderField: "Authorization")
        let postString = ["key": key,
            ] as! [String: String]
        let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
        urlRequest.httpBody = jsonUser
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
            do{
                guard let received = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    completion ("Could not get JSON from responseData as dictionary")
                    return
                }
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
