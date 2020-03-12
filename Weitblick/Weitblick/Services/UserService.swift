//
//  UserService.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 08.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//
/*
 ============
 UserService:
 ============
    - resetPassword function
    - changePassword function
    - getUserData: Fetch User data based on given Token
    - uploadImage function
 */

import UIKit

class UserService{

    static func resetPassword( email: String, completion: @escaping (_ response : String) -> ()){
        let url = NSURL(string: "https://weitblicker.org/rest/auth/password/reset/")
        var request = URLRequest(url:url! as URL as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postString = ["email": email] as [String: String]
        let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
        request.httpBody = jsonUser
        let session = URLSession.shared
        let task = session.dataTask(with: request){
            (data, response, error) in
            
            guard error == nil else{
                print("error calling POST on /password/reset")
                completion("error calling POST on /password/reset")
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                completion("Error: did not receive data")
                return
            }
            do{
                guard let received = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
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
        let url = NSURL(string: "https://weitblicker.org/rest/auth/password/change/")
        var request = URLRequest(url:url! as URL as URL)
        var key : String = ""
        key = UserDefaults.standard.string(forKey: "key")!
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Token  " + key, forHTTPHeaderField: "Authorization")
        let postString = ["new_password1": password_new, "new_password2": password_new2] as [String: String]
        let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
        request.httpBody = jsonUser
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
            do{
                guard let received = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    completion("Could not get JSON from responseData as dictionary")
                    return
                }
                print("The Recieved Message is: " + received.description)
                completion(received["detail"] as! String)
            }catch{
                completion("error parsing response from POST on /password/change")
                print("error parsing response from POST on /password/change")
                return
            }
        }
        task.resume()
    }
    
    static func getUserData(completion : @escaping (_ user: User?, _ error: NSError?) -> ()){
        
        let url = NSURL(string: "https://weitblicker.org/rest/auth/user/")
        var request = URLRequest(url:url! as URL as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(" Token " + UserDefaults.standard.string(forKey: "key")!, forHTTPHeaderField: "Authorization")
        do{
            let session = URLSession.shared
            let task = session.dataTask(with: request){
                (data, response, error) in
                if let data = data{
                    let jsondata = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let userDict = jsondata as? NSDictionary{
                        guard let username = userDict.value(forKey: "username") else { return }
                        let usernameString = username as! String
                        var userImageString = ""
                        guard let imgUrl = userDict.value(forKey: "image") else { return }
                        if let imageString = imgUrl as? String{
                            userImageString = imageString
                        }
                        guard let firstName = userDict.value(forKey: "first_name") else { return }
                        let firstNameString = firstName as! String
                        guard let lastName = userDict.value(forKey: "last_name") else { return }
                        let lastNameString = lastName as! String
                        
                        guard let cycle_euro = userDict.value(forKey: "cycle_euro") else { return }
                        let cycleEuroNumber = cycle_euro as! NSNumber
                        let cycleEuroFloat = Double.init(truncating: cycleEuroNumber)
                        
                        guard let cycle_km = userDict.value(forKey: "cycle_km") else { return }
                        let cycleKmNumber = cycle_km as! NSNumber
                        let cycleKmFloat = Double.init(truncating: cycleKmNumber)
                        
                        UserDefaults.standard.set(firstNameString, forKey: "firstname")
                        UserDefaults.standard.set(lastNameString, forKey: "lastname")
                        UserDefaults.standard.set(usernameString, forKey: "username")
                        let user = User(username: usernameString, image: userImageString, km: cycleKmFloat, euro: cycleEuroFloat)
                        completion(user,nil)
                    }
                }else{
                    let error = error as NSError?
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
    
    static func uploadImage(paramName: String, fileName: String, image: UIImage, completion: ()-> ()) {
        let url = URL(string: Constants.userURL)

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("Token " + UserDefaults.standard.string(forKey: "key")!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        let firstname = UserDefaults.standard.string(forKey: "firstname")?.description
        let lastname  = UserDefaults.standard.string(forKey: "lastname")?.description
        let username = UserDefaults.standard.string(forKey: "username")?.description
        let filename = username!.description + Date.init().dateAndTimetoStringISO().description
        // Add the image data to the raw http request data
        var string = ""
        let boundstring = "\r\n--\(boundary)\r\n"
        data.append(boundstring.data(using: .utf8)!)
        string = "Content-Disposition: form-data; name=\"image\"; filename=\"\(filename).png\"\r\n"
        data.append(string.data(using: .utf8)!)
        string = "Content-Type: image/png\r\n\r\n"
        data.append(string.data(using: .utf8)!)
        data.append(image.pngData()!)
        
        data.append(boundstring.data(using: .utf8)!)
        string = "Content-Disposition: form-data; name=\"first_name\"\r\n"
        data.append(string.data(using: .utf8)!)
        string = "Content-Type: text/plain; charset=UTF-8\r\n\r\n"
        data.append(string.data(using: .utf8)!)
        data.append((firstname!.description + "\r\n").data(using: .utf8)!)
        
        data.append(boundstring.data(using: .utf8)!)
        string = "Content-Disposition: form-data; name=\"last_name\"\r\n"
        data.append(string.data(using: .utf8)!)
        string = "Content-Type: text/plain; charset=UTF-8\r\n\r\n"
        data.append(string.data(using: .utf8)!)
        data.append((lastname!.description + "\r\n").data(using: .utf8)!)
        
        data.append(boundstring.data(using: .utf8)!)
        string = "Content-Disposition: form-data; name=\"username\"\r\n"
        data.append(string.data(using: .utf8)!)
        string = "Content-Type: text/plain; charset=UTF-8\r\n\r\n"
        data.append(string.data(using: .utf8)!)
        data.append((username!.description + "\r\n").data(using: .utf8)!)
        string = "\r\n--\(boundary)--\r\n"
        data.append(string.data(using: .utf8)!)
        
        
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                }
            }
        }).resume()
    }
}
