//
//  ProjectDetailViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import Charts
import MapKit
import MarkdownKit



extension UIColor {

    /**
    Creates a UIColor object for the given rgb value which can be specified
    as HTML hex color value. For example:

        let color = UIColor(rgb: 0x8046A2)
        let colorWithAlpha = UIColor(rgb: 0x8046A2, alpha: 0.5)

    - parameter rgb: color value as Int. To be specified as hex literal like 0xff00ff
    - parameter alpha: alpha optional alpha value (default 1.0)
    */
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((rgb & 0xff0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00ff00) >>  8) / 255
        let b = CGFloat((rgb & 0x0000ff)      ) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

}


class ProjectDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var project_tableView: UITableView!
    @IBOutlet weak var project_detail_image: UIImageView!
    @IBOutlet weak var project_detail_title: UILabel!
    @IBOutlet weak var project_detail_location: UILabel!
    @IBOutlet weak var project_detail_description: UILabel!
    @IBOutlet weak var uebersicht: UILabel!
    @IBOutlet weak var project_detail_date: UILabel!
    @IBOutlet weak var project_detail_maplocation: UILabel!
    @IBOutlet weak var map: MKMapView!
    //Alle Variablen müssen auf 0 bzw false gesetzt werden
    var count = 0
    var postCount = 0
    var counter_milestones = 0
    var counter_news = 0
    var counter_events = 0
    var counter_blogs = 0
    var counter_sponsor = 0
    var counter_partner = 0
    var partner_loaded : Bool =  false
    var partner_head : Bool = false
    var partner_list : Bool = false
    var spenden_loaded : Bool = false
    var fahrrad_loaded : Bool =  false
    var sponsor_loaded : Bool =  false
    var sponsor_head : Bool =  false
    var sponsor_list : Bool =  false
    var meilenstein_loaded : Bool = false
    var meilenstein_head : Bool = false
    var meilenstein_list : Bool = false
    var blog_loaded : Bool =  false
    var blog_head : Bool =  false
    var blog_list : Bool =  false
    var news_loaded : Bool = false
    var news_head : Bool = false
    var news_list : Bool = false
    var event_loaded : Bool = false
    var event_head : Bool = false
    var event_list : Bool = false
    var more_news_loaded : Bool = false
    var more_event_loaded : Bool = false
    var more_blog_loaded : Bool = false
    @IBOutlet weak var ButtonFav: UIButton!
    @IBOutlet weak var PieChart: PieChartView!
    var project_object: Project?
    
//Alle benötigten Daten für diese View laden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.project_tableView.delegate = self
        self.project_tableView.dataSource = self
        self.loadProjectDetail()
        self.loadMap()
        self.project_tableView.reloadData()
    }


    @IBOutlet var photoSliderView: PhotoSliderView!

    //Map mit dem zugehörigen Marker laden
    func loadMap(){
        let annotation = MKPointAnnotation()
        annotation.title = project_object?.getLocation.getAddress
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees((project_object?.getLocation.getLatitude)!),
        longitude: CLLocationDegrees((project_object?.getLocation.getLongitude)!))
        self.map.addAnnotation(annotation)
        map.setCenter(annotation.coordinate, animated: true)
        let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        self.map.setRegion(region, animated: true)
    }


    //Favoriten Button darstellen
    func setUpButton(){
        ButtonFav.addTarget(self, action: Selector(("favButton:")), for : UIControl.Event.touchUpInside)
    }
    var clicked = 0
    //Falls Herz angeklickt Icon ändern
    @IBAction func favButton(_ sender: UIButton) {
        if(clicked == 0){
        let image = UIImage(systemName: "heart.fill")
        sender.setImage(image, for: UIControl.State.normal)
            clicked = 1
            return
        } else if(clicked==1){
            let image = UIImage(systemName: "heart")
            sender.setImage(image, for: UIControl.State.normal)
            clicked = 0
        }

    }
    
    //Alle Daten zugehörig zum Projekt laden
    //News, Events und Blogs anhand der ProjektID über den jeweiligen Service in listen speichern

    func loadProjectDetail(){
        let dispatchGroup = DispatchGroup()
        let markdownParser = MarkdownParser()
        let blogIDs : [Int] = project_object?.getBlogs ?? []
        for id in blogIDs{
            dispatchGroup.enter()
            BlogService.getBlogByID(id: id) { (blogEntry) in
                DispatchQueue.main.async {
                    self.blogList.append(blogEntry)
                    dispatchGroup.leave()
                       }
                   }
               }
        let newsIDs : [Int] = project_object?.getNews ?? []
        for id in newsIDs{
            dispatchGroup.enter()
            DataService.getNewsByID(id: id) { (newsEntry) in
                DispatchQueue.main.async {
                    self.newsList.append(newsEntry)
                    dispatchGroup.leave()
                       }
                   }
               }
        let eventIDs : [Int] = project_object?.getEvents ?? []
        for id in eventIDs{
            dispatchGroup.enter()
            EventService.getEventByID(id: id) { (event) in
                DispatchQueue.main.async {
                    self.eventList.append(event)
                    dispatchGroup.leave()
                                  }
                              }
                          }

                dispatchGroup.notify(queue: .main) {
                //Alle bools auf false setzten damit TableView richtig anzeiget wird
                self.partner_loaded =  false
                self.partner_head = false
                self.partner_list = false
                self.spenden_loaded = false
                self.fahrrad_loaded  =  false
                self.sponsor_loaded  =  false
                self.sponsor_head  =  false
                self.sponsor_list  =  false
                self.meilenstein_loaded  = false
                self.meilenstein_head  = false
                self.meilenstein_list  = false
                self.blog_loaded  =  false
                self.blog_head  =  false
                self.blog_list  =  false
                self.news_loaded  = false
                self.news_head  = false
                self.news_list  = false
                self.event_loaded  = false
                self.event_head  = false
                self.event_list  = false
                self.more_blog_loaded = false
                self.more_news_loaded = false
                self.more_event_loaded = false
                self.postCount = 0
                self.counter_milestones = 0
                self.counter_news = 0
                self.counter_events = 0
                self.counter_blogs = 0
                self.counter_sponsor = 0
                self.counter_partner = 0
                print("PARTNERLOADED AB HIER")
                self.project_tableView.reloadData()

               }
        //Daten für Projektdetailansicht den Labels zuweisen
        project_detail_description.attributedText = markdownParser.parse(project_object!.getDescription)
        project_detail_title.text = project_object?.getName
        project_detail_location.text = project_object?.getHosts[0].getCity.uppercased()
        project_detail_location.font = UIFont(name: "OpenSans-Bold", size: 15)
        project_detail_maplocation.text = project_object?.getLocation.getAddress
        project_detail_date.text = project_object?.getPublished.dateAndTimetoString()
        photoSliderView.configure(with: project_object!.getGallery)

    }

    //Listen anlegen für die kommenden Daten
    var newsList : [NewsEntry] = []
    var blogList : [BlogEntry] = []
    var eventList : [Event] = []
    var projectList : [Project] = []
    var locationList : [Location] = []
    var locationListID : [Int] = []
    var counter = 0


    //Größe der TableView festlegen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.project_object!.getCelLCount + 6
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Prüfen ob Projekt Partners hat und ob diese bereitsgeladen sind
        //Falls nicht geladen können und Projekt besitzt Partner diese in Zellen anzeigen lassen
        if(self.project_object!.getPartners.count > 0 && self.partner_loaded == false){
            let cell =  tableView.dequeueReusableCell(withIdentifier:"partner_cell", for: indexPath)as! P_DetailPartnerCell
            if(self.partner_head == false){
                //Zelle zeigt Title an (Bild im Storyboard festgelegt)
                self.partner_head = true
                let pahead_cell = cell.partner_tableView.dequeueReusableCell(withIdentifier:"pahead_cell", for: indexPath)as! PaHeadCell
                        return pahead_cell
                    }
            if(self.partner_list == false){
                //List Zelle zeigt Liste alle Partner mit Logo, Beschreibung und Name an
                let palist_cell = cell.partner_tableView.dequeueReusableCell(withIdentifier:"palist_cell", for: indexPath)as! PaListCell
                if(self.counter_partner < (self.project_object?.getPartners.count)!){
                    palist_cell.palist_name.text = self.project_object?.getPartners[counter_partner].getName
                    palist_cell.palist_description.text = self.project_object?.getPartners[counter_partner].getDescription
                    palist_cell.palist_image.image = self.project_object?.getPartners[counter_partner].getLogo
                            self.counter_partner = self.counter_partner + 1
                            return palist_cell
                        }else{
                            self.partner_list = true
                        }
                    }
                    self.partner_loaded = true
                    return cell
                }

        //Spenden Zelle
        //Prüfen ob Projekt Spenden besitzt und ob diese bereits geladen sind
        //Falls nicht und Spenden vorhanden, diese anzeigen lassen
        //Eine Zelle für ganze Spendenbereich hier angelegt
        if (self.spenden_loaded == false && self.project_object?.getDonationGlobal.getDonationGoal != 0.0) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"spenden_cell", for: indexPath)as! P_DetailSpendenCell
            cell.spendenkonto.text = self.project_object?.getDonationGlobal.getDonationAccount.getIban
            cell.spendenstand.text = self.project_object?.getDonationGlobal.getCurrent.description
            cell.spendenziel.text = self.project_object?.getDonationGlobal.getDonationGoal.description
            cell.spendenbeschreibung.text = self.project_object?.getDonationGlobal.getDescription
            self.spenden_loaded = true
            cell.backgroundView = UIImageView(image: UIImage(named: "yellowxxxhdpi")!)
            return cell
                }

        //Fahrrad Zelle
        //Falls Projekt zum Radeln geeignet Zelle und diese bereits nicht schon anzeigen lassen
        else if (project_object!.getCycleObject.getDonations.count  > 0 && self.fahrrad_loaded == false){
            let cell = tableView.dequeueReusableCell(withIdentifier:"fahrrad_cell", for: indexPath)as! P_DetailFahrradCell
            cell.gefahren.text = project_object!.getCycleObject.getkmSum.description + " km"
            cell.spendenstand.text = project_object!.getCycleObject.getEuroSum.description + " €"
            cell.spendenziel.text = project_object!.getCycleObject.getEuroGoal.description + " €"
            cell.radfahrer_anzahl.text = project_object!.getCycleObject.getCyclists.description
            counter = 3
            self.fahrrad_loaded = true
            return cell
        }
        //Sponsor Zelle
        //Falls Projekt Sponsor besitzt und diese nicht geladen, anzeigen lassen
        if (self.project_object!.getCycleObject.getDonations.count > 0 && self.sponsor_loaded == false) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"sponsor_cell", for: indexPath)as! P_DetailSponsorCell
            if(self.sponsor_head == false){
                //Zelle zeigt Title an (Bild im Storyboard festgelegt)
                let sphead_cell = cell.sponsor_tableView.dequeueReusableCell(withIdentifier:"sphead_cell", for: indexPath)as! SpHeadCell
                self.sponsor_head = true
                return sphead_cell
            }
            if(self.sponsor_list == false){
                //Zelle zeigt Liste an Sponsoren an
                let splist_cell = cell.sponsor_tableView.dequeueReusableCell(withIdentifier:"splist_cell", for: indexPath)as! SpListCell
                if(self.counter_sponsor < (self.project_object?.getCycleObject.getDonations.count)!){
                    //mehrere Sponsoren könnten sein
                    splist_cell.splist_sponsor.text = self.project_object?.getCycleObject.getDonations[0].getSponsor.getName
                    splist_cell.splist_description.text = self.project_object?.getCycleObject.getDonations[0].getSponsor.getDescription
                    splist_cell.splist_image.image = self.project_object?.getCycleObject.getDonations[0].getSponsor.getLogo
                    self.counter_sponsor += 1
                    return splist_cell
                    
                }else {
                    self.sponsor_list = true
                        }
                    }
                    self.sponsor_loaded = true
                    return cell
                }
        //Meilensteine Zelle
        //Falls Meilensteine im Projekt vorhanden und nicht bereit sgeladen, diese anzeigen
        
        if (project_object!.getMilestones.count > 0 && self.meilenstein_loaded == false){
            let cell = tableView.dequeueReusableCell(withIdentifier:"meilenstein_cell", for: indexPath)as! P_DetailMeilensteinCell
            if(self.meilenstein_head == false){
                //Zelle zeigt Title an (Bild im Storyboard festgelegt)
                let mehed_cell = cell.meilenstein_tableView.dequeueReusableCell(withIdentifier:"mehead_cell", for: indexPath)as! MeHeadCell
                self.meilenstein_head = true
                mehed_cell.backgroundView = UIImageView(image: UIImage(named: "greenxxxhdpi")!)
                return mehed_cell
                    }
            if(self.meilenstein_list == false){
                //Zelle gibt Liste der Meilensteine an
                let melist_cell = cell.meilenstein_tableView.dequeueReusableCell(withIdentifier:"melist_cell", for: indexPath)as! MeListCell
                if(self.counter_milestones < (self.project_object?.getMilestones.count)!){
                    melist_cell.melist_date.text = self.project_object!.getMilestones[self.counter_milestones].getDate.dateAndTimetoString()
                    melist_cell.melist_headline.text = self.project_object?.getMilestones[self.counter_milestones].getName
                    melist_cell.melist_description.text = self.project_object?.getMilestones[self.counter_milestones].getDescription
                    self.counter_milestones += 1
                    melist_cell.backgroundView = UIImageView(image: UIImage(named: "greenxxxhdpi")!)
                    return melist_cell
                        }else{
                            self.meilenstein_list = true
                        }
                        }
                    self.meilenstein_loaded = true
                    cell.backgroundView = UIImageView(image: UIImage(named: "greenxxxhdpi")!)
                    return cell
                }


        //Blog Zelle
        //Falls Projekt Blogs besitzt und diese nicht bereits geladen, anzeigen lassen
            
                if (self.project_object!.getBlogs.count >  0 && self.blog_loaded == false){
                    let cell = tableView.dequeueReusableCell(withIdentifier:"blog_cell", for: indexPath)as! P_DetailBlogCell
                    if(self.blog_head == false){
                        //Zelle zeigt Title an (Bild im Storyboard festgelegt)
                            let blhead_cell = cell.blog_tableView.dequeueReusableCell(withIdentifier:"blhead_cell", for: indexPath)as! BlHeadCell
                        self.blog_head = true
                        blhead_cell.backgroundView = UIImageView(image: UIImage(named: "bluegreyldpi")!)
                        return blhead_cell
                         }
                    else if(self.blog_list == false){
                        //Zelle zeigt Liste mit Blogs an
                            let bllist_cell = cell.blog_tableView.dequeueReusableCell(withIdentifier:"bllist_cell", for: indexPath)as! BlListCell
                        if(self.counter_blogs < ((self.project_object?.getBlogs.count)!) && self.blogList.count>0){
                                bllist_cell.bllist_author.text = self.blogList[self.counter_blogs].getAuthor.getName
                                bllist_cell.bllist_title.text = self.blogList[self.counter_blogs].getTitle
                                bllist_cell.bllist_date.text = self.blogList[self.counter_blogs].getCreationDate.dateAndTimetoString()
                                bllist_cell.bllist_description.text = self.blogList[self.counter_blogs].getText
                                bllist_cell.bllist_image.image = self.blogList[self.counter_blogs].getImage
                                self.counter_blogs += 1
                            bllist_cell.backgroundView = UIImageView(image: UIImage(named: "bluegreyldpi")!)
                                return bllist_cell
                            }else{
                                self.blog_list = true
                        }


                        }
                    if(self.blogList.count > 3 && self.more_blog_loaded == false){
                        //Falls Anzahl der zugehörigen Blogs > 3 "Mehr anzeigen" Button sichtbar in seperater Zelle
                        let more_cell = cell.blog_tableView.dequeueReusableCell(withIdentifier:"show_more_blog_cell", for: indexPath)as! ShowMoreBlogCell
                        more_cell.show_more_button.addTarget(self, action: #selector(ProjectDetailViewController.goToBlogFromBlogList), for: .touchUpInside)
                        self.more_blog_loaded = true
                        return more_cell

                    }
                   cell.backgroundView = UIImageView(image: UIImage(named: "bluegreyldpi")!)
                    self.blog_loaded = true
                    return cell
                }

                //News Zelle
                //Falls Projekt News besitzt und diese nicht bereits geladen, news anzeigen
                
                 if (self.project_object!.getNews.count > 0 && self.news_loaded == false){
                    let cell = tableView.dequeueReusableCell(withIdentifier:"news_cell", for: indexPath)as! P_DetailNewsCell
                    if(self.news_head == false){
                        //Zelle zeigt Title an (Bild im Storyboard festgelegt)
                        let nehead_cell = cell.news_tableView.dequeueReusableCell(withIdentifier:"nehead_cell", for: indexPath)as! NeHeadCell
                        self.news_head = true
                        return nehead_cell
                    }else if(self.news_list == false){
                        //Zelle zeigt Liste an News an
                        let nelist_cell = cell.news_tableView.dequeueReusableCell(withIdentifier:"nelist_cell", for: indexPath)as! NeListCell
                        if(self.counter_news < self.newsList.count && self.counter_news < 3){
                            nelist_cell.nelist_date.text = self.newsList[self.counter_news].getCreationDate.dateAndTimetoString();
                            nelist_cell.nelist_author.text = self.newsList[self.counter_news].getAuthor.getName
                            nelist_cell.nelist_description.text = self.newsList[self.counter_news].getText
                            nelist_cell.nelist_title.text = self.newsList[self.counter_news].getTitle
                            nelist_cell.nelist_location.text = self.newsList[self.counter_news].getHost.getLocation.getAddress
                            nelist_cell.nelist_image!.image = self.newsList[self.counter_news].getImage
                            nelist_cell.nelist_profileimg.image = self.newsList[self.counter_news].getAuthor.getImage

                            self.counter_news += 1
                            return nelist_cell
                        }else{
                             self.news_list = true
                        }
                    }
                    if(self.project_object!.getNews.count > 3 && self.more_news_loaded == false){
                        //Falls Newsanzahl > 3 Button "Mehr anzeigen" darstellen in seperater Zelle
                        let more_cell = cell.news_tableView.dequeueReusableCell(withIdentifier:"show_more_news", for: indexPath)as! ShowMoreNewsCell
                         more_cell.show_more_button.addTarget(self, action: #selector(ProjectDetailViewController.goToNewsFromNewsList), for: .touchUpInside)
                        self.more_news_loaded = true
                        return more_cell
                    }
                    self.news_loaded = true
                    return cell
                }
        //Event Zelle
        //Falls Projekt Events besitzt und diese nicht bereits geladen, events anzeigen

                 if (self.project_object!.getEvents.count > 0 && self.event_loaded == false){
                    let cell = tableView.dequeueReusableCell(withIdentifier:"event_cell", for: indexPath)as! P_DetailEventCell
                    if(self.event_head == false){
                        //Zelle zeigt Title an (Bild im Storyboard festgelegt)
                        let evhead_cell = cell.event_tableView.dequeueReusableCell(withIdentifier:"evhead_cell", for: indexPath)as! EvHeadCell
                        self.event_head = true
                        evhead_cell.backgroundView = UIImageView(image: UIImage(named: "bluegreyldpi")!)
                        return evhead_cell

                    }
                    if(self.event_list == false){
                        //Zelle zeigt Liste an Events zu diesem Projekt an
                        let evlist_cell = cell.event_tableView.dequeueReusableCell(withIdentifier:"evlist_cell", for: indexPath)as! EvListCell
                         if(self.counter_events < self.eventList.count && self.counter_events < 3){
                            evlist_cell.evlist_date.text = self.eventList[self.counter_events].getStartDate.dateAndTimetoString()
                            evlist_cell.evlist_location.text = self.eventList[self.counter_events].getLocation.getAddress
                            evlist_cell.evlist_title.text = self.eventList[self.counter_events].getTitle
                            evlist_cell.evlist_time.text = "18 Uhr"//self.eventList[self.counter_events]
                            evlist_cell.evlist_description.text = self.eventList[self.counter_events].getDescription
                            self.counter_events += 1
                            evlist_cell.backgroundView = UIImageView(image: UIImage(named: "bluegreyldpi")!)
                            return evlist_cell
                        }else{
                        self.event_list = true

                        }
                    }
                    if(self.eventList.count > 3 && self.more_event_loaded == false){
                         //Falls Eventanzahl > 3 Button "Mehr anzeigen" darstellen in seperater Zelle
                        let more_cell = cell.event_tableView.dequeueReusableCell(withIdentifier:"show_more_event_cell", for: indexPath)as! ShowMoreEventsCell
                         more_cell.show_more_event.addTarget(self, action: #selector(ProjectDetailViewController.goToEventFromEventList), for: .touchUpInside)
                        self.more_event_loaded = true
                       return more_cell
                    }
                    self.event_loaded = true
                    cell.backgroundView = UIImageView(image: UIImage(named: "bluegreyldpi")!)
                    return cell
                 }
         let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
         return cell
        }
    
    
    
//TabBarController Icons als aktiv anzeigen lassen beim wechseln vom Projektdetail zu Blog/News/Events
    @objc func goToBlogFromBlogList(sender:UIButton!){
           self.tabBarController?.selectedIndex = 2
       }
    
    
    @objc func goToNewsFromNewsList(sender:UIButton!){
           self.tabBarController?.selectedIndex = 1
       }
    
    @objc func goToEventFromEventList(sender:UIButton!){
        self.tabBarController?.selectedIndex = 1
    }
    
    
    
//Bei betätigen des Buttons "Mehr anzeigen" bei Blog/Event/News auf anderen View wechseln
//Diesem View aber die ganze Liste von Blogs/News/Events übergeben damit dieser nur die dazugehörigen zu diesem Projekt vollständig anzeigen kann
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                 if segue.destination is BlogViewController
                 {
                     let blogController = segue.destination as? BlogViewController
                     blogController?.blogListProjectDetail = self.blogList

                 }
                if segue.destination is NewsViewController
                 {
                  let newsController = segue.destination as? NewsViewController
                    newsController?.newsListProjectDetail = self.newsList
                 
                   }
                if segue.destination is EventViewController
                    {
                    let eventController = segue.destination as? EventViewController
                    eventController?.eventListProjectDetail = self.eventList
                    }
             }
}
