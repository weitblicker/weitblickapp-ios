//
//  EventDetailController.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 27.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit
import MapKit
import MarkdownKit

class EventDetailViewController: UIViewController {
    
    
    @IBOutlet weak var event_detail_date: UILabel!
    @IBOutlet weak var slider: PhotoSliderView!
    @IBOutlet weak var event_detail_city: UILabel!
    @IBOutlet weak var event_detail_title: UILabel!
    @IBOutlet weak var event_detail_location : UILabel!
    @IBOutlet weak var event_detail_description:
    UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var event_object : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEventDetail()
        DispatchQueue.main.async {
           
          
            let CLLCoordType = CLLocationCoordinate2D(latitude: self.event_object!.getLocation.getLatitude,longitude: self.event_object!.getLocation.getLongitude)
            let anno = MKPointAnnotation()
            anno.coordinate = CLLCoordType
            self.mapView.addAnnotation(anno)
            let region = MKCoordinateRegion.init(center: CLLCoordType, latitudinalMeters: 2000, longitudinalMeters: 2000)
            self.mapView.setRegion(region, animated: true)
        }

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
    
    func loadEventDetail(){
         
         let markdownParser = MarkdownParser(customElements: [MarkDownLink])
        event_detail_description.attributedText = markdownParser.parse(event_object!.getDescription)
        event_detail_description.sizeToFit()
        event_detail_title.text = event_object?.getTitle
        event_detail_location.text = "Afrika"
        event_detail_city.text = event_object!.getHost
        event_detail_date.text = event_object?.getStartDate.dateAndTimetoString()
        slider.configure(with: [(self.event_object?.getImage)!])
         
         
     }
    

 

}
