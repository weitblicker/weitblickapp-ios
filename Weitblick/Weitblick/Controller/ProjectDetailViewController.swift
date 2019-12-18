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




class ProjectDetailViewController: UIViewController {



    @IBOutlet weak var project_detail_image: UIImageView!
    
    @IBOutlet weak var project_detail_title: UILabel!
    
    @IBOutlet weak var project_detail_location: UILabel!
    
    @IBOutlet weak var project_detail_description: UILabel!
    
    @IBOutlet weak var uebersicht: UILabel!
    
    
    
    @IBOutlet weak var map: MKMapView!
    var count = 0
    var postCount = 0
    
    @IBOutlet weak var ButtonFav: UIButton!

    //@IBOutlet weak var ButtonFilled: UIButton!

    @IBOutlet weak var PieChart: PieChartView!
    
    var project_object: Project?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.project_object?.getCycleIDCount == 1){

        customizeChart(dataPoints: stats, values: goals.map{ Double($0) })
        } else{
            PieChart.alpha = 0
            uebersicht.alpha = 0
        }
        loadProjectDetail()

      //  setUpButton()

    }
    
    
    @IBOutlet var photoSliderView: PhotoSliderView!
    

    func customizeChart(dataPoints: [String], values: [Double]) {
      // TO-DO: customize the chart here
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
          dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        var  colors: [UIColor] = []
              let colorOne = UIColor(rgb: 0xFF9900)
              let colorTwo = UIColor(rgb: 0x2C2C2C)
        let colorThree = UIColor(rgb : 0x0972b3)
               colors.append(colorTwo)
        colors.append(colorOne)
         colors.append(colorThree)
        pieChartDataSet.colors = colors


        // 3. Set ChartData
         let pieChartData = PieChartData(dataSet: pieChartDataSet)
         let format = NumberFormatter()
         format.numberStyle = .none
         let formatter = DefaultValueFormatter(formatter: format)
         pieChartData.setValueFormatter(formatter)

        // 4. Assign it to the chart’s data
        PieChart.data = pieChartData;

        // ausblenden
      //  PieChart.highlightPerTapEnabled = false
        PieChart.usePercentValuesEnabled = false

        //Text auf Chart ausblenden
        PieChart.drawEntryLabelsEnabled = false
        //Zahlenangaben auf Chart ausblenden
        //pieChartDataSet.drawValuesEnabled = false
        //Legende ausblenden
       // PieChart.legend.enabled = false
       
        
       loadMap()
        
        
    }
    
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
        project_detail_description.text = project_object?.getDescription.html2String
        project_detail_title.text = project_object?.getName
        project_detail_location.text = project_object?.getLocation.getAddress
        // project_detail_image.image = img
        photoSliderView.configure(with: project_object!.getGallery)
        
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
