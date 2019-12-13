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
    //var projectTitle : String = ""
    var projectId : Int = -1;

    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func centerLocationButton(_ sender: UIButton) {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    @IBOutlet weak var cycleProjectTitle: UIButton!
    
    @IBAction func startDataTracking(_ sender: Any) {
        print(UserDefaults.standard.bool(forKey: "isLogged"))
        if(!UserDefaults.standard.bool(forKey: "isLogged")){
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }else{
            if(UserDefaults.standard.integer(forKey: "projectID") != 0){
                self.performSegue(withIdentifier: "goToMapView", sender: self)
            }else{
                self.showAlertMess(userMessage: "Kein Projekt ausgewählt!")
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(UserDefaults.standard.string(forKey: "projectName") != nil){
            self.cycleProjectTitle.setTitle(UserDefaults.standard.string(forKey: "projectName"), for: .normal)
        }else{
            self.cycleProjectTitle.setTitle("Kein Projekt ausgewählt", for: .normal)
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
            mapViewController?.projectid = UserDefaults.standard.integer(forKey: "projectID")

        }
    }
    
    func showAlertMess(userMessage: String){

        let alertView = UIAlertController(title: "Achtung!", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        self.present(alertView, animated: true, completion: nil)

    }
}

extension BikeViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    
}
