//
//  BikeViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class BikeViewController: UIViewController {
    
    var list : [CLLocation] = []
    var i = 0;
    var totalDistance : Double = 0;
    var locationSaved = CLLocation()
    var startTracking = false;
    var startCalculateDistance = false;
    var distance = CLLocationDistance();
    let locationManager = CLLocationManager()
    let regionInMeters : Double = 1000;

    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func startDataTracking(_ sender: Any) {
        print(UserDefaults.standard.bool(forKey: "isLogged"))
        if(!UserDefaults.standard.bool(forKey: "isLogged")){
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }else{
            self.performSegue(withIdentifier: "goToMapView", sender: self)
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization(){
        print("In checkLocationAuthorization")
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            print("AUTHORIZED")
            self.mapView.showsUserLocation = true
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
            self.mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MapViewController
        {
            let mapViewController = segue.destination as? MapViewController
            mapViewController?.locationManager = self.locationManager


        }
    }
}

extension BikeViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else{ return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        self.mapView.setRegion(region, animated: true)
        
//        if(startTracking){
//            if(self.startCalculateDistance){
//                self.list.append(location)
//                if(self.list.count >= 2){
//                    let start = self.list[self.list.count-2]
//                    let end = self.list[self.list.count-1]
//                    self.totalDistance += end.distance(from: start)
//                    self.distanceLbl.text = (round(self.totalDistance)/1000).description + " km"
//                    self.speedLbl.text = (round(location.speed * 3.6*1000)/1000).description + "km/h"
//                }
//            }else{
//                var total: Double = 0.0
//                for i in 0..<self.list.count - 1 {
//                    let start = list[i]
//                    let end = list[i + 1]
//                    let distance = end.distance(from: start)
//                    total += distance
//
//                }
//                self.list = []
//                let alert = UIAlertController(title: "Distance Calculated", message: total.description + " meters", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//                NSLog("The \"OK\" alert occured.")
//                }))
//                self.present(alert, animated: true, completion: nil)
//                self.startTracking = false
//                self.distanceLbl.text = ""
//                self.totalDistance = 0
//            }
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    
}
