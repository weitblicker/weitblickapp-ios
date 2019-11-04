//
//  LoginViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit



class LoginViewController: UIViewController {
    
    
    @IBOutlet fileprivate var emailField : UITextField!
    
    @IBOutlet fileprivate var passwordField : UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //emailField.text=""
        //spasswordField.text=""
    }
    

    @IBAction func MailField(_ sender: UITextField) {
    }
    
    
    @IBAction func PaawordField(_ sender: UITextField) {
    }
    
    
    @IBAction func LoginButton(_ sender: UIButton) {
    }
    
    @IBAction func newPassword(_ sender: UIButton) {
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
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
