//
//  P_DetailFahrradCell.swift
//  Weitblick
//
//  Created by Zuzanna Mielczarek on 29.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

//Zelle für die Fahrradinformationen in der Tabelle auf dem ProjectDetailController 

import Foundation
import UIKit
import Charts


class P_DetailFahrradCell: UITableViewCell {
    
    @IBOutlet weak var pie_chart: PieChartView!
    @IBOutlet weak var spendenstand: UILabel!
    @IBOutlet weak var radfahrer_anzahl: UILabel!
    @IBOutlet weak var fahrrad_chart: UILabel!
    @IBOutlet weak var spendenziel: UILabel!
    @IBOutlet weak var gefahren: UILabel!
    @IBOutlet weak var fahrrad_button: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
          dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet, Farben anpassen für die einzelnen Stücke in PieChart
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
        pie_chart.data = pieChartData;

        // ausblenden
      //  PieChart.highlightPerTapEnabled = false
        pie_chart.usePercentValuesEnabled = false

        //Text auf Chart ausblenden
        pie_chart.drawEntryLabelsEnabled = false
        //Zahlenangaben auf Chart ausblenden
        //pieChartDataSet.drawValuesEnabled = false
        //Legende ausblenden
       // PieChart.legend.enabled = false    
        
    }

}
