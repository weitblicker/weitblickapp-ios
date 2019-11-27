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
        
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        //HTTP Request
        
        let myUrl = URL(string: "https://new.weitblicker.org/rest/auth/registration")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
           
        let postString = ["username": self.username.text!,
                          "email": self.email.text!,
                          "password1": self.password.text!,
                          "password2": self.password2.text!,
                             ] as [String: String]
           
           do {
               request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
           } catch let error {
               print(error.localizedDescription)
              self.showAlertMess(userMessage: "Irgendwas hat nicht geklappt. Versuche es nochmal")
               return
           }
           
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
          if (error != nil){
               self.showAlertMess(userMessage: "Request konnte nicht durchegführt werden")
               print("error=\(String(describing: error))")
               return
           }
           
           //Let's convert response sent from a server side code to a NSDictionary object:
      /*     do {
               let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
               
               if let parseJSON = json {
                   
                   let userId = parseJSON["userId"] as? String
                   print("User id: \(String(describing: userId!))")
                   
                   if (userId?.isEmpty)!{
                
                     self.showAlertMess(userMessage: "Request konnte nicht durchegführt werden")
                       return
                   } else {
                       self.showAlertMess(userMessage: "Request konnte nicht durchegführt werden")
                   }
                   
               } else {
                  
                   self.showAlertMess(userMessage: "Request konnte nicht durchegführt werden")
               }
           } catch {
               
              
              self.removeActivityIndicator(activityIndicator: myActivityIndicator)
              self.showAlertMess(userMessage: "Request konnte nicht durchegführt werden")
               print(error)
           }*/
           }
           
           task.resume()
      
        
        
        
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
           {
               DispatchQueue.main.async
                {
                       activityIndicator.stopAnimating()
                       activityIndicator.removeFromSuperview()
               }
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
    
    
           
          
       
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
