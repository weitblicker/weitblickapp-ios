//
//  ProfileViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true

      /* self.layer.cornerRadius = (self.frame.size.width ) / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.black.cgColor*/
    }
}

class ProfileViewController: UIViewController {


    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var profile_email: UILabel!
    @IBOutlet weak var profile_password: UILabel!
    @IBOutlet weak var profile_donation: UILabel!
    @IBOutlet weak var profile_route: UILabel!

    @IBAction func button_edit_password(_ sender: Any) {

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        profile_image.image = UIImage(named: "profile_image")
        profile_image.layer.cornerRadius = profile_image.frame.size.width/2
        profile_image.clipsToBounds = true
        profile_image.layer.borderWidth = 2
        profile_image.layer.borderColor = UIColor.black.cgColor


    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }






    @IBAction func logOut(_ sender: Any) {


        let user = UserDefaults.standard
        let key = user.object(forKey: "key")
        print("KEY IN PROFILE")
        print(key)
       // let key = "8c757db6fe8b56977a92f270282ef4f543c726bc"

        let url = NSURL(string: "https://new.weitblicker.org/rest/auth/registration/")
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var urlRequest = URLRequest(url : (url as URL?)!,cachePolicy:URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
              urlRequest.httpMethod = "POST"
              urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
              urlRequest.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
             // urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

         let postString = ["key": key,

            ] as! [String: String]

            do{
            let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
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

                 guard let userKey = received["key"] as? Int else {
                    DispatchQueue.main.async {
                    self.showErrorMessage(message: received.description)

                                  }
                   return
                 }

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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
