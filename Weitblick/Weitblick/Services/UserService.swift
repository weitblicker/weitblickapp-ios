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
          let url = NSURL(string: "https://weitblicker.org/rest/auth/password/reset/")
          let str = "surfer:hangloose"
          let test2 = Data(str.utf8).base64EncodedString();
          var request = URLRequest(url:url! as URL as URL)
          request.httpMethod = "POST"
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Token " + UserDefaults.standard.string(forKey: "key")! , forHTTPHeaderField: "Authorization")
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
         let url = NSURL(string: "https://weitblicker.org/rest/auth/password/change/")
         let str = "surfer:hangloose"
         let test2 = Data(str.utf8).base64EncodedString();
         var request = URLRequest(url:url! as URL as URL)
        
        var key : String = ""
        key = UserDefaults.standard.string(forKey: "key")!

        
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
         request.addValue("Token  " + key, forHTTPHeaderField: "Authorization")
        
        let postString = ["new_password1": password_new, "new_password2": password_new2] as [String: String]
     /*   let postString = ["key": key,"old_password": password_old, "new_password1": password_new, "new_password2": password_new2] as [String: String]*/
        
        
        print("POST STRING")
        print(postString)

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
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        print(test2)
        var request = URLRequest(url:url! as URL as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(" Token " + UserDefaults.standard.string(forKey: "key")!, forHTTPHeaderField: "Authorization")
        //print("Basic " + test2 + " Token " + UserDefaults.standard.string(forKey: "key")!)
        //request.addValue("Token " + UserDefaults.standard.string(forKey: "key")!, forHTTPHeaderField: "Authorization")
        let user = UserDefaults.standard

        //let postString = ["key": user.string(forKey: "key"), "username": "", "first_name" : "", "last_name" : ""] as! [String: String]
        do{
            //let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
            //request.httpBody = jsonUser
            let session = URLSession.shared
            print("In Get UserData 1\n")
            let task = session.dataTask(with: request){
                (data, response, error) in
                print("In Get Userdata2\n")
                if let data = data{
                    let jsondata = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let userDict = jsondata as? NSDictionary{
                        guard let username = userDict.value(forKey: "username") else { return }
                        let usernameString = username as! String
                        var userImageString = ""
                         print("In GetUserdata4\n")
                        guard let imgUrl = userDict.value(forKey: "image") else { return }
                        if let imageString = imgUrl as? String{
                            userImageString = imageString
                        }
                         print("In GetUserdata5\n")
                        guard let firstName = userDict.value(forKey: "first_name") else { return }
                        let firstNameString = firstName as! String
                         print("In GetUserdata6\n")
                        guard let lastName = userDict.value(forKey: "last_name") else { return }
                        let lastNameString = lastName as! String
                        
                         print("In GetUserdata7\n")
                        UserDefaults.standard.set(firstNameString, forKey: "firstname")
                        UserDefaults.standard.set(lastNameString, forKey: "lastname")
                        UserDefaults.standard.set(usernameString, forKey: "username")
                        print("In Get UserData 8")
                        let user = User(username: usernameString, image: userImageString, km: 0.0, euro: 0.0)
                        print(user)
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
        print(string)
        string = "Content-Disposition: form-data; name=\"image\"; filename=\"\(filename).png\"\r\n"
        data.append(string.data(using: .utf8)!)
        print(string)
        string = "Content-Type: image/png\r\n\r\n"
        data.append(string.data(using: .utf8)!)
        print(string)
        data.append(image.pngData()!)
        //add data username, firstname, lastname
        
        data.append(boundstring.data(using: .utf8)!)
        string = "Content-Disposition: form-data; name=\"first_name\"\r\n"
        data.append(string.data(using: .utf8)!)
        string = "Content-Type: text/plain; charset=UTF-8\r\n\r\n"
        data.append(string.data(using: .utf8)!)
        data.append((username!.description + "\r\n").data(using: .utf8)!)
        
        data.append(boundstring.data(using: .utf8)!)
        string = "Content-Disposition: form-data; name=\"last_name\"\r\n"
        data.append(string.data(using: .utf8)!)
        string = "Content-Type: text/plain; charset=UTF-8\r\n\r\n"
        data.append(string.data(using: .utf8)!)
        data.append((username!.description + "\r\n").data(using: .utf8)!)
        
        data.append(boundstring.data(using: .utf8)!)
        string = "Content-Disposition: form-data; name=\"username\"\r\n"
        data.append(string.data(using: .utf8)!)
        string = "Content-Type: text/plain; charset=UTF-8\r\n\r\n"
        data.append(string.data(using: .utf8)!)
        data.append((username!.description + "\r\n").data(using: .utf8)!)
//        Content-Disposition: form-data; name="file1"; filename="a.txt"
//        Content-Type: text/plain
        
            
//
//        data.append(("last_name: " + firstname! + "\r\n\r\n").data(using: .utf8)!)
//        data.append(("first_name: " + lastname! + "\r\n\r\n").data(using: .utf8)!)
// cycle_km
// cycle_euro
//
        string = "\r\n--\(boundary)--\r\n"
        data.append(string.data(using: .utf8)!)
        print(string)
        
        
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print("Success")
                    print(json)
                }
            }
        }).resume()
    }
}
