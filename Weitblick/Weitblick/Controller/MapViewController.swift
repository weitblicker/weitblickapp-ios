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
    var currentDistance: Double = 0;
    var totalDistance : Double = 0;
    var startTracking = false;
    var startCalculateDistance = false;
    var trackFinished = false;
    var distance = CLLocationDistance();
    var locationManager = CLLocationManager()
    let regionInMeters : Double = 750;
    var lastPostRequestDate: Date = Date()
    var lastDistance : Double = 0;
    var hasbeenPaused : Bool = false;
    var timer : Timer = Timer.init()
    var start : Date = Date()
    var end : Date = Date()
    var tours = UserDefaults.standard.integer(forKey: "tours")
    var projectid: Int = 0

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
        let user = UserDefaults.standard
        var tours = user.integer(forKey: "tours")
        tours += 1
        user.set(tours, forKey: "tours")
        user.synchronize()
    }

    func setupSegmentations(){
        print("StartTimer")
        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        start = Date()
    }

    @objc func fireTimer(){
        print("FIRETIMER")
        let distanceToSent = round(((totalDistance - currentDistance)/1000)*100)/100
        //self.showErrorMessage(message: "DistanceToSend: " + distanceToSent.description)

        currentDistance = totalDistance
        end = Date()
        SegmentService.sendSegment(start: start, end: end, distance: distanceToSent, projectID: projectid, tourID: tours) { (response) in
            print("In SegmentService Completionhandler")
            print(response)
            self.start = self.end
        }

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
            startTracking = true
            centerViewOnUserLocation()
            setupSegmentations()
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
            startTracking = true
            self.map.showsUserLocation = true
            centerViewOnUserLocation()
            setupSegmentations()
            locationManager.startUpdatingLocation()
            break
        }
    }

    @IBAction func clickPauseContinue(_ sender: Any) {
        if(startTracking){
            startTracking = false
            self.timer.fire()
            self.timer.invalidate()
            self.stopPlayButton.setImage(UIImage(named: "greenButtonPlay"), for: UIControl.State.normal)
        }else{
            startTracking = true
            hasbeenPaused = true;
            setupSegmentations()
            self.stopPlayButton.setImage(UIImage(named: "orangeButtonStop"), for: UIControl.State.normal)

        }
    }

    @IBAction func EndTrackingClicked(_ sender: Any) {
        
        
        self.timer.fire()
        self.timer.invalidate()
        startTracking = false;
        self.trackFinished = true;
        // PASSING DATA TO RESULTPAGE
        self.performSegue(withIdentifier: "goToTrackResult", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ResultMapViewController
        {
           // let resultMapViewController = segue.destination as? ResultMapViewController
            // TODO DATA PASSING

            var DestViewController : ResultMapViewController = segue.destination as! ResultMapViewController
            DestViewController.DistanceText = distanceLbl.text ?? "fehler"
            DestViewController.DonationText = donationLbl.text ?? "fehler"

        }
    }
}


extension MapViewController : CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{ return }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        self.map.setRegion(region, animated: true)

        if(self.startTracking){
            self.list.append(location)
            print(self.list.count)
            if(self.list.count >= 2){
                var speed = location.speed
                if(hasbeenPaused){
                    hasbeenPaused = false;
                    speed = -1
                }

                if(!(speed < 0.0)){
                    let start = self.list[self.list.count-2]
                    let end = self.list[self.list.count-1]
                    self.totalDistance += end.distance(from: start)
                    print("Distance calculated : " + end.distance(from: start).description)
                    //print(totalDistance.description + " m")
                    let distanceinKM = self.totalDistance/1000
                    print((round(distanceinKM*100)/100).description + " km")
                    self.distanceLbl.text = (round(distanceinKM*100)/100).description + " km"
                    self.distanceLbl.text = doubleToKm(double: totalDistance)
                    print("Total Distance: " + distanceLbl.text!)
                    self.donationLbl.text = (round((distanceinKM*0.1)*100)/100).description + " €"
                }
                print("speed is negative, no distance added")
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

    func showErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        self.present(alertView, animated: true, completion:nil)
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
