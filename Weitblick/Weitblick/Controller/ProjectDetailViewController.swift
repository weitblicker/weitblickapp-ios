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



    @IBOutlet weak var map: MKMapView!
    var count = 0
    var postCount = 0
    var counter_milestones = 0
    var counter_news = 0
    var counter_events = 0
    var counter_blogs = 0

    @IBOutlet weak var ButtonFav: UIButton!

    //@IBOutlet weak var ButtonFilled: UIButton!

    @IBOutlet weak var PieChart: PieChartView!

    var project_object: Project?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.project_tableView.reloadData()


        loadProjectDetail()
        loadMap()

      //  setUpButton()

       self.project_tableView.delegate = self
       self.project_tableView.dataSource = self


    }


    @IBOutlet var photoSliderView: PhotoSliderView!



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



    func setUpButton(){
        ButtonFav.addTarget(self, action: Selector(("favButton:")), for : UIControl.Event.touchUpInside)

    }


     var clicked = 0
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

    func loadProjectDetail(){

        let markdownParser = MarkdownParser()
        project_detail_description.attributedText = markdownParser.parse(project_object!.getDescription)
        project_detail_title.text = project_object?.getName
        project_detail_location.text = project_object?.getLocation.getAddress
        // project_detail_image.image = img
        print("GALLERY COUNT")
        print(project_object?.getGallery.count)
        photoSliderView.configure(with: project_object!.getGallery)

    }



       var projectList : [Project] = []
       var locationList : [Location] = []
       var locationListID : [Int] = []
        var counter = 0


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

       // if(tableView == self.project_tableView)
            return 13


       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        print("IN TABLEVIEW")

        //partner
       // if (self.project_object!.getPartnerID.count > 0 ){
        if(counter == 0){
        print("IN PARTNER")
             let cell =  tableView.dequeueReusableCell(withIdentifier:"partner_cell", for: indexPath)as! P_DetailPartnerCell

            if(indexPath.row == 0){
                print ("IN PARTNER IF 1")
            let pahead_cell = cell.partner_tableView.dequeueReusableCell(withIdentifier:"pahead_cell", for: indexPath)as! PaHeadCell
                return pahead_cell
            }else if (indexPath.row == 1){
                print ("IN PARTNER IF 2")
                let palist_cell = cell.partner_tableView.dequeueReusableCell(withIdentifier:"palist_cell", for: indexPath)as! PaListCell
                palist_cell.palist_name.text = "Volkswagen"
                palist_cell.palist_description.text = "Der große Sponsor VW spendet 50000€ fur dieses Projekt"
                palist_cell.palist_image.image = UIImage(named: "Weitblick")
                counter = 1
                return palist_cell

            }


            return cell


        }
            //spenden
      //  else if ( self.project_object!.getCycleIDCount > 0) {
        else if (counter == 1){
            print("IN Spenden")
            let cell = tableView.dequeueReusableCell(withIdentifier:"spenden_cell", for: indexPath)as! P_DetailSpendenCell
            cell.spendenkonto.text = project_object!.getHosts[0].getBankAccount.getIban
            cell.spendenstand.text = project_object!.getCycleObject.getEuroSum.description
            cell.spendenziel.text = project_object!.getCycleObject.getEuroGoal.description
            if(project_object!.getCycleObject.getDonations.count > 0){
                 cell.spendenbeschreibung.text = project_object!.getCycleObject.getDonations[0].getDescription
            }
          
            counter = 2

            return cell
        }
            //fahrrad
       // else if( self.project_object!.getCycleIDCount > 0){
        else if (counter == 2){
            print("IN FAHRRAD")
            let cell = tableView.dequeueReusableCell(withIdentifier:"fahrrad_cell", for: indexPath)as! P_DetailFahrradCell
//            if(!(self.project_object?.getCycleObject.getDonations.isEmpty)!){
//
//                cell.customizeChart(dataPoints: stats, values: goals.map{ Double($0) })
//                   } else{
//                       PieChart.alpha = 0
//
//                   }

            cell.gefahren.text = project_object!.getCycleObject.getkmSum.description
            cell.radfahrer_anzahl.text = "34"
            counter = 3

            return cell

        }

        //sponsor
        else if (counter == 3){
            print ("IN SPONSOR")
            let cell = tableView.dequeueReusableCell(withIdentifier:"sponsor_cell", for: indexPath)as! P_DetailSponsorCell
            if(indexPath.row == 4){
                print("IN SPONSOR IF 1")
            let sphead_cell = cell.sponsor_tableView.dequeueReusableCell(withIdentifier:"sphead_cell", for: indexPath)as! SpHeadCell
            sphead_cell.sphead_image!.image = UIImage (named: "Weitblick")
            return sphead_cell
            }else if (indexPath.row == 5){
                print("IN SPONSOR IF 2")
             let splist_cell = cell.sponsor_tableView.dequeueReusableCell(withIdentifier:"splist_cell", for: indexPath)as! SpListCell
                
                if(self.project_object!.getCycleObject.getDonations.count > 0){

                splist_cell.splist_sponsor.text = self.project_object!.getCycleObject.getDonations[0].getSponsor.getName
                splist_cell.splist_description.text = self.project_object!.getCycleObject.getDonations[0].getSponsor.getDescription
                }
                counter = 4
                return splist_cell

            }
            return cell
        }


        //meilensteine
        else if (counter == 4){
            print ("IN MEILENSTEIN")
            let cell = tableView.dequeueReusableCell(withIdentifier:"meilenstein_cell", for: indexPath)as! P_DetailMeilensteinCell
            if (indexPath.row == 6){
                print ("IN MEILENSTEIN IF 1")
                let mehed_cell = cell.meilenstein_tableView.dequeueReusableCell(withIdentifier:"mehead_cell", for: indexPath)as! MeHeadCell
                mehed_cell.mehead_image!.image = UIImage(named: "Weitblick")
                return mehed_cell
            }
                else if(indexPath.row == 7){
                    print ("IN MEILENSTEIN IF 2")
                    let melist_cell = cell.meilenstein_tableView.dequeueReusableCell(withIdentifier:"melist_cell", for: indexPath)as! MeListCell
//                melist_cell.melist_date.text = project_object?.getMilestones[self.counter_milestones].getDate.dateAndTimetoString()
                if((project_object?.getMilestones.count)! > 0){
                melist_cell.melist_headline.text = project_object?.getMilestones[self.counter_milestones].getName
                melist_cell.melist_description.text = project_object?.getMilestones[self.counter_milestones].getDescription
                self.counter_milestones += 1
                }

                counter = 5
                return melist_cell

                }

            return cell
        }


        //blog
       // else if (self.project_object!.getBlogs.count >  0){
        else if (counter == 5){
            print("IN BLOG")

            let cell = tableView.dequeueReusableCell(withIdentifier:"blog_cell", for: indexPath)as! P_DetailBlogCell
                if (indexPath.row == 8){
                    print ("IN BLOG IF 1")
                    let blhead_cell = cell.blog_tableView.dequeueReusableCell(withIdentifier:"blhead_cell", for: indexPath)as! BlHeadCell
                blhead_cell.imageView!.image = UIImage (named: "blog.png")
                return blhead_cell
                 }
                 if (indexPath.row == 9){
                    print ("IN BLOG IF 2")
                    let bllist_cell = cell.blog_tableView.dequeueReusableCell(withIdentifier:"bllist_cell", for: indexPath)as! BlListCell
                    bllist_cell.bllist_author.text = "Blog auto"
                    bllist_cell.bllist_title.text = "Title des Blogs"
                    bllist_cell.bllist_date.text = "12.12.2019"
                    bllist_cell.bllist_description.text = "Beipsieltext für einen Blogeintrag für der sehr serh lange sein soll und über Zeilen gehen muss"
                    bllist_cell.bllist_image.image = UIImage(named: "Weitblick")
                    counter = 6
                    return bllist_cell
                }

            let more_cell = tableView.dequeueReusableCell(withIdentifier:"show_more_blog_cell", for: indexPath)as! ShowMoreCell
            return more_cell



            return cell


        }

        //news
       // else if (self.project_object!.getNews.count > 0){
        else if (counter == 6){
            print("IN NEWS")
            let cell = tableView.dequeueReusableCell(withIdentifier:"news_cell", for: indexPath)as! P_DetailNewsCell

            if(indexPath.row == 10){
                print("IN NEWS IF 1")
            let nehead_cell = cell.news_tableView.dequeueReusableCell(withIdentifier:"nehead_cell", for: indexPath)as! NeHeadCell
                return nehead_cell
            }else if (indexPath.row == 11){
                 print("IN NEWS IF 2")
                let nelist_cell = cell.news_tableView.dequeueReusableCell(withIdentifier:"nelist_cell", for: indexPath)as! NeListCell
                nelist_cell.nelist_author.text = "VorName NAchname"
                nelist_cell.nelist_description.text = "sdhbvshdvbhdbvhjbdvhbd"
                nelist_cell.nelist_title.text = "News Title"
                nelist_cell.nelist_location.text = "Osnabrück"
                nelist_cell.nelist_image!.image = UIImage(named: "Weitblick")
                counter = 7
            }

//           let more_cell = tableView.dequeueReusableCell(withIdentifier:"show_more_news", for: indexPath)as! ShowMoreCell
//            return more_cell

            return cell

        }

        //event
        else if(counter == 7){
            print("IN EVENt")
            let cell = tableView.dequeueReusableCell(withIdentifier:"event_cell", for: indexPath)as! P_DetailEventCell
            if(indexPath.row == 12){
              print("IN EVENT IF 1")
                let evhead_cell = cell.event_tableView.dequeueReusableCell(withIdentifier:"evhead_cell", for: indexPath)as! EvHeadCell
                evhead_cell.imageView!.image = UIImage (named: "aktuelles.b.png")
                return evhead_cell

            }
            else if(indexPath.row == 13){
                print("IN EVENT IF 2")
                let evlist_cell = cell.event_tableView.dequeueReusableCell(withIdentifier:"evlist_cell", for: indexPath)as! EvListCell
                evlist_cell.evlist_date.text =  "12-12-12"
                evlist_cell.evlist_location.text = "Osnabrück"
                evlist_cell.evlist_title.text = "News title"
                evlist_cell.evlist_time.text = "18 UHr"
                evlist_cell.evlist_description.text = "sajhvfhsdvcfhsdbch"
                return evlist_cell
            }
        }
        let more_cell = tableView.dequeueReusableCell(withIdentifier:"show_more_event_cell", for: indexPath)as! ShowMoreCell
        return more_cell


    /*let cell = tableView.dequeueReusableCell(withIdentifier:"news_cell", for: indexPath)as! P_DetailNewsCell
        return cell*/

    }


}
