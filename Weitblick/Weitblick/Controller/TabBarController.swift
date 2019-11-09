//
//  TabBarController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class TabBarController: SwipeableTabBarController {
    
    var eventCollection : EventCollection = EventCollection()
    var newsCollection : NewsCollection = NewsCollection()
    var blogCollection : BlogCollection = BlogCollection()
    var projectCollection : ProjectCollection = ProjectCollection()
    
    var eventsLoaded : Bool = false
    var newsLoaded : Bool = false
    var blogsLoaded : Bool = false
    var projectsLoaded : Bool = false

    var selector : String = ""
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.sideBySide
    }
    override func viewWillAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        
        nav?.barStyle = UIBarStyle.default
        
        let imageView = UIImageView(frame : CGRect(x : 0 , y : 0, width : 40 , height : 40))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named : "Weitblick")
        imageView.image = image
        
        navigationItem.titleView = imageView
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
