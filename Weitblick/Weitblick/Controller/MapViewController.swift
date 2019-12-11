//
//  MapViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var list : [CLLocation] = []
    var i = 0;
    var totalDistance : Double = 0;
    var startTracking = true;
    var startCalculateDistance = false;
    var trackFinished = false;
    var distance = CLLocationDistance();
    var locationManager = CLLocationManager()
    let regionInMeters : Double = 100;
    var lastPostRequestDate: Date = Date()
    var lastDistance : Double = 0;

    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var donationLbl: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var stopPlayButton: UIButton!

    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        self.stopPlayButton.setImage(UIImage(named: "orangeButtonStop"), for: UIControl.State.normal)
        super.viewDidLoad()
        checkLocationServices()
        distanceLbl.text = "0.00 km"
        donationLbl.text = "0.00 €"
    }

    override func viewWillAppear(_ animated: Bool) {
        if(self.trackFinished){
            self.trackFinished = false;
            dismiss(animated: true, completion: nil)
        }
    }

    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            // SHOW ALERT TO TURN GPS ON
        }
    }

    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            self.map.setRegion(region, animated: true)
        }
    }

    func checkLocationAuthorization(){
        print("In checkLocationAuthorization")
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            print("AUTHORIZED")
            self.map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            print("DENIED")
            // SHOW ALERT HOW TO TURN ON PERMISSIONS
            break
        case .notDetermined:
            print("NOT DETERMINED")
            locationManager.requestAlwaysAuthorization()
            break
        case .restricted:
            print("RESTRICTED")
            // SHOW ALERT
            break
        case .authorizedAlways:
            print("AUTHORIZED ALWAYS")
            self.map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        }
    }

    @IBAction func clickPauseContinue(_ sender: Any) {
        if(startTracking){
            startTracking = false
            self.stopPlayButton.setImage(UIImage(named: "orangeButtonStop"), for: UIControl.State.normal)
        }else{
            startTracking = true
            self.lastPostRequestDate = Date.init()
            self.stopPlayButton.setImage(UIImage(named: "greenButtonPlay"), for: UIControl.State.normal)

        }
    }

    @IBAction func EndTrackingClicked(_ sender: Any) {
        self.trackFinished = true;
        // PASS DATA TO SERVER
        // Alle 30 Sekunden POST Request
        //
        self.performSegue(withIdentifier: "goToTrackResult", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ResultMapViewController
        {
            let resultMapViewController = segue.destination as? ResultMapViewController
            // TODO DATA PASSING
        }
    }
}

extension MapViewController : CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{ return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        self.map.setRegion(region, animated: true)

        if(self.startTracking){
            print("Tracking Location ..")
            print("Location: " + location.description)
            self.list.append(location)
            print(self.list.count)
            if(self.list.count >= 2){
                print("Calculating Distance ..")
                let start = self.list[self.list.count-2]
                let end = self.list[self.list.count-1]
                self.totalDistance += end.distance(from: start)
                print("Distance calculated : " + end.distance(from: start).description)
                //print(totalDistance.description + " m")
                let distanceinKM = self.totalDistance/1000
                //print((round(distanceinKM*100)/100).description + " km")
                //self.distanceLbl.text = (round(distanceinKM*100)/100).description + " km"
                self.distanceLbl.text = doubleToKm(double: totalDistance)
                self.donationLbl.text = (round((distanceinKM*0.1)*100)/100).description + " €"
            }
        }
    }

    func doubleToKm(double : Double) -> String{
        let s = round((double/1000)*100)/100
        return s.description + " km"
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}




/*

 let url = NSURL(string: "https://new.weitblicker.org/rest/cycle/segment")
        let str = "surfer:hangloose"
        let test2 = Data(str.utf8).base64EncodedString();
        var request = URLRequest(url : (url as URL?)!,cachePolicy:URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + test2, forHTTPHeaderField: "Authorization")
                    // urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let postString = ["project" : Int, "tour" : Int, "token": String , "distance": float , "start" : YYYY-MM-DDTHH:MM:SS+2:00, "end" : YYYY-MM-DDTHH:MM:SS+2:00 ] as [String: String]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }catch let error{
            print(error.localizedDescription)
            showAlertMess(userMessage: "Irgendwas ist nicht richtig beim Login")
            return
        }
 */
