//
//  PopOverViewController.swift
//  Weitblick
//
//  Created by Jana  on 13.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController, UIPopoverPresentationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    }
    
    
      

      func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
          return .none
      }

}
