//
//  RegisterViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet weak var checkbox: UIButton!
    
//    @IBAction func showPopoverButtonAction(_ sender: Any) {
//    //get the button frame
//    /* 1 */
//    let button = sender as? UIButton
//    let buttonFrame = button?.frame ?? CGRect.zero
//
//    /* 2 */
//    //Configure the presentation controller
//    let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "PopOverViewController") as? PopOverViewController
//    popoverContentController?.modalPresentationStyle = .popover
//
//    /* 3 */
//    if let popoverPresentationController = popoverContentController?.popoverPresentationController {
//    popoverPresentationController.permittedArrowDirections = .up
//    popoverPresentationController.sourceView = self.view
//    popoverPresentationController.sourceRect = buttonFrame
//        popoverPresentationController.delegate = self as! UIPopoverPresentationControllerDelegate
//    if let popoverController = popoverContentController {
//    present(popoverController, animated: true, completion: nil)
//    }
//    }
//    }
//
//    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//    return .none
//    }
//
//    //UIPopoverPresentationControllerDelegate
//    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
//
//    }
//
//    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
//    return true
//    }
//
    
    
    //popover versuch 2
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//           return .none
//       }
//       
//       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//           
//           // All popover segues should be popovers even on iPhone.
//           if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
//               popoverController.delegate = self
//               popoverController.sourceRect = button.bounds
//           }
//           
//           guard let identifier = segue.identifier, let segueIdentifer = SegueIdentifier(rawValue: PopOverViewController) else { return }
//           if segueIdentifer == .showObjects, let objectsViewController = segue.destination as? PopOverViewController {
//               
//           }
//       }
    
    
    //ende 2
    
    //Popover 3
    
   
    @IBOutlet var popover: UIScrollView!
    
    @IBAction func go(){
        print ("IN GO")
        self.view.addSubview(popover)
        popover.center = self.view.center
       
    }
    
    
    @IBAction func backToRegister(_ sender: Any) {
        self.popover.removeFromSuperview()
    }
    
/*   func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "go"){
        let dest = segue.destination
        if let pop = dest.popoverPresentationController{
            pop.delegate = self
        }
    }
  /*  let controller = segue.destination
        if let nv = controller.popoverPresentationController{
            nv.delegate = self
        }*/
        
    }*/
    

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //ende 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
                  tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)

        //view verschieben bei tastatur
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    //view verschieben wenn tastaur erscheint
       @objc func keyboardWillShow(sender: NSNotification) {
            self.view.frame.origin.y = -230 // Move view 150 points upward
       }

       @objc func keyboardWillHide(sender: NSNotification) {
            self.view.frame.origin.y = 0 // Move view to original position
       }

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var errorText: UILabel!
    
    
    var clicked = 0
    
    func setUpButton(){
           checkbox.addTarget(self, action: Selector(("chechbox:")), for : UIControl.Event.touchUpInside)

       }
    
    @IBAction func checkbox(_ sender: Any) {
        
        if(clicked == 0){
        let image = UIImage(named:  "checkbox_full.png")
            (sender as AnyObject).setImage(image, for: UIControl.State.normal)
            clicked = 1
            
            return
        } else if(clicked==1){
            let image = UIImage(named: "checkbox_empty.png")
            (sender as AnyObject).setImage(image, for: UIControl.State.normal)
            clicked = 0
        }
        
    }
    
      
    


    @IBAction func registerButton(_ sender: UIButton) {
        
        if(clicked == 0 ){
            showAlertMess(userMessage: "Bitte AGBs bestätigen");
            return;
        }
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

        RegisterService.registerWithData(username: self.username.text!,email: self.email.text!, password1: self.password.text!, password2: self.password2.text!) { (response) in
        
          if(response != "" ){
                DispatchQueue.main.async {
                 self.showAlertMess(userMessage: response)
                    let register = UserDefaults.standard.bool(forKey: "isRegisterd")

                                    if(register == true){
                                       print("IN DER UMLEITUNG")
                                    //Auf login View umleiten
                                
                                      DispatchQueue.main.async {
                                          self.reloadInputViews()
                                      self.dismiss(animated: true, completion: nil)
                                    }
                               }
                 }
            }
        }


    }


    func showAlertMess(userMessage: String){
        let alertView = UIAlertController(title: "Achtung!", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        self.present(alertView, animated: true, completion: nil)

    }
    func  showErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        self.present(alertView, animated: true, completion:nil)
    }

    @IBAction func InfoButton(_ sender: UIButton) {
        let message:String = "Der Username wird öffentlich sichtbar sein"

                       let alertController:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)

                       let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
                       alertController.addAction(alertAction)
                       present(alertController, animated: true, completion: nil)
    }



    @IBAction func textFieldShouldReturn(_ sender: UITextField) {
        self.view.endEditing(true)


    }

    @IBAction func passwortWiederholenClose(_ sender: UITextField) {
          self.view.endEditing(true)
    }

    @IBAction func mailClose(_ sender: UITextField) {
         self.view.endEditing(true)
    }

    @IBAction func usernameClose(_ sender: UITextField) {
        self.view.endEditing(true)
    }




}
