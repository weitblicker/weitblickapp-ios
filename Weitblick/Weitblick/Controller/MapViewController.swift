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
    var locationSaved = CLLocation()
    var startTracking = false;
    var startCalculateDistance = false;
    var trackFinished = false;
    var distance = CLLocationDistance();
    var locationManager = CLLocationManager()
    let regionInMeters : Double = 100;

    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var donationLbl: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var stopPlayButton: UIButton!
    
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()
        if(self.trackFinished){
            dismiss(animated: true, completion: nil)
            self.trackFinished = false;
        }
        self.startTracking = true;
        checkLocationServices()
    }
    
    
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
            self.stopPlayButton.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        }else{
            startTracking = true
            self.stopPlayButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
        }
    }
    
    
    @IBAction func EndTrackingClicked(_ sender: Any) {
        
        self.trackFinished = true;
        
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
            self.list.append(location)
            if(self.list.count >= 2){
                let start = self.list[self.list.count-2]
                let end = self.list[self.list.count-1]
                self.totalDistance += end.distance(from: start)
                print(totalDistance.description + " m")
                let distanceinKM = self.totalDistance/1000
                print((round(distanceinKM*100)/100).description + " km")
                self.distanceLbl.text = (round(distanceinKM*100)/100).description + " km"
                if(location.speed < 0){
                    self.speedLbl.text = "0 km/h"
                }else{
                    self.speedLbl.text = (round(location.speed * 3.6*10)/10).description + " km/h"
                }
                self.donationLbl.text = (round((distanceinKM*0.1)*100)/100).description + " €"
            }
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
