//
//  RegisterViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
  
    
    @IBAction func registerButton(_ sender: UIButton) {
        if (self.username.text!.isEmpty){
                   showAlertMess(userMessage: "Username-Feld darf nicht leer sein")
                   return;

               }
        
        if (self.email.text!.isEmpty){
            showAlertMess(userMessage: "Email-Feld darf nicht leer sein")
            return;

        }
        if (self.password.text!.isEmpty){
            showAlertMess(userMessage: "Passwort-Feld darf nicht leer sein")
             return;
            
        }
        if (self.password2.text!.isEmpty){
            showAlertMess(userMessage: "Passwort wiederholen- Feld darf nicht leer sein")
             return;
            
        }
        
      
        if (self.password.text != self.password2.text){
            showAlertMess(userMessage: "Passwörter sind nicht gleich!")
             return;
           
        }
            //POST-Request zum Registrieren des Users
        
        //Store Data
    /*    UserDefaults.standard.set(self.email.text, forKey:"userEmail")
        UserDefaults.standard.set(self.password.text, forKey:"userPassword")
        UserDefaults.standard.synchronize()
            
            let alertView = UIAlertController(title: "Achtung!", message: "Registrierung erfolgreich. Vielen Dank!", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){
                action in
                self.dismiss(animated: true,completion:nil)
            }
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alertView, animated: true, completion: nil)
            print("User registriert")*/
        
        
        //POST-Request zum Registrieren des Users
        
       
            
               
            
           
        let url = NSURL(string: "https://new.weitblicker.org/rest/auth/registration/")
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var urlRequest = URLRequest(url : (url as URL?)!,cachePolicy:URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
              urlRequest.httpMethod = "POST"
              urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
              urlRequest.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
             // urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
              
         let postString = ["username": self.username.text!,
                               "email": self.email.text!,
                               "password1": self.password.text!,
                               "password2": self.password2.text!,
                                         ] as [String: String]
       
    
           // let jsonUser: Data
             // do{
            let  jsonUser = try! JSONSerialization.data(withJSONObject: postString, options:[])
                urlRequest.httpBody = jsonUser
                print("User: ")
                print(jsonUser.html2String)
            /*  }catch {
                print("Error: cannot create JSON from todo")
                return
              }*/
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
                 print("The Recieved User is: " + received.description)

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
    
    
    func showAlertMess(userMessage: String){
        let alertView = UIAlertController(title: "Achtung!", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        self.present(alertView, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func InfoButton(_ sender: UIButton) {
        let message:String = "Der Username wird öffentlich sichtbar sein"
   
                       let alertController:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)

                       let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
                       alertController.addAction(alertAction)
                       present(alertController, animated: true, completion: nil)
    }
    
    
           // 11
           func textFieldShouldReturn(textField: UITextField) -> Bool {
                
               self.view.endEditing(true)
                
               return true
            
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
