//
//  TabBarController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class TabBarController: SwipeableTabBarController,UINavigationControllerDelegate {

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

       loadNavImages()

    }

    @objc func goToProfile(_ sender:UIBarButtonItem!)
       {

        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)

           }



    public func loadNavImages(){
               let image = UIImage(named : "Weitblick")
               let imageView = UIImageView(image: image)
               imageView.frame = CGRect(x: 0, y: 0, width: 170, height: 45)
               imageView.contentMode = .scaleAspectFit
               let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 60))
               titleView.addSubview(imageView)
               titleView.backgroundColor = .clear
               self.navigationItem.titleView = titleView
        let rightBarButton = UIBarButtonItem(title: "Profil", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TabBarController.goToProfile(_:)))
               self.navigationItem.rightBarButtonItem = rightBarButton

    }


  

   

    // TODO

//    private func getEvents(f : [EventDecodable]){
//        print("Loading events..")
//        for news in f {
//            guard let id = news.id else { return }
//            guard let title = news.title else { return }
//            guard let text = news.text else { return }
//            guard let gallery = news.gallery else { return }
//            guard let created = news.added else { return }
//            guard let updated = news.updated else { return }
//            guard let range = news.range else { return }
//            let newsEntry = NewsEntry(id : Int.init(id)!, title : title, text : text, gallery : gallery, created : self.handleDate(date: created), updated : self.handleDate(date: updated), range : range);
//            self.newsCollection.addNewsEntry(newsEntry: newsEntry)
//        }
//        print("News loaded.")
//    }


    
}
