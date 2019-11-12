//
//  ProjectDetailViewController.swift
//  Weitblick
//
//  Created by Jana  on 31.10.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit
import Charts




class ProjectDetailViewController: UIViewController {



    @IBOutlet weak var projectImage: UIImageView!


    @IBOutlet weak var ButtonFav: UIButton!

    //@IBOutlet weak var ButtonFilled: UIButton!

    @IBOutlet weak var PieChart: PieChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeChart(dataPoints: stats, values: goals.map{ Double($0) })

      //  setUpButton()


        // Do any additional setup after loading the view.
    }

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
        colors.append(UIColor.green)
        colors.append(UIColor.blue)
        colors.append(UIColor.red)
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
       // PieChart.usePercentValuesEnabled = false

        //Text auf Chart ausblenden
        PieChart.drawEntryLabelsEnabled = false
        //Zahlenangaben auf Chart ausblenden
        pieChartDataSet.drawValuesEnabled = false
        //Legende ausblenden
        PieChart.legend.enabled = false
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


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
