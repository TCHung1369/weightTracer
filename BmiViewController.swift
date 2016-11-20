//
//  BmiViewController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 03/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import CoreData
import Charts


class BmiViewController: UIViewController,NSFetchRequestResult,NSFetchedResultsControllerDelegate {

    @IBOutlet var labelText: UILabel!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var lineChartView: LineChartView!
    let coreDataHelper = CoreDataHelper()
    var fetchResultController : NSFetchedResultsController<WeightData>?
    var weightDatas : [WeightData] = []
    let dateFomatter = DateFormatter()
    
    var bmiArray = [Double]()
    var dateArray = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarController = self.tabBarController as! TabBarController
        self.weightDatas = tabBarController.weightDatas
        
        self.dateFomatter.dateFormat = "MM-dd"
        
        for i in 0..<self.weightDatas.count{
            let bmiData = self.weightDatas[i].bmiData
            let dateData = self.dateFomatter.string(from: self.weightDatas[i].dateData)
            self.bmiArray.append(Double(bmiData))
            self.dateArray.append(dateData)
        }
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.bounds
        self.myImageView.addSubview(visualEffectView)
        
        if self.weightDatas.count <= 1{
            self.lineChartView.noDataText = "Please provide two datas at least"
        }else{
            self.setChart(dataPoints: self.dateArray, values: self.bmiArray)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
   }

extension BmiViewController{
    //Setting Chart Data
    
    func setChart(dataPoints:[String],values:[Double]){
        
        if dataPoints == [] || values == []{
            self.lineChartView.noDataText = "Please provide two datas at least"
        }else{
        
        var sumData : Double = 0.0
        var averageData : Int = 0
        
        let lineChartFormatter = BarChartFomatter()
        let xaxis = XAxis()
        lineChartFormatter.setValues(values: dataPoints)
        var lineDataEntries = [ChartDataEntry]()
        
        for i in 0..<values.count{
            sumData += values[i]
            let lineDataEntry = ChartDataEntry(x: Double(i), y: values[i])
            lineDataEntries.append(lineDataEntry)
        }
        
        let bmiDataColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1)
        averageData = Int(Int(sumData) / values.count)
          
        xaxis.valueFormatter = lineChartFormatter
        
        
        let chartDataSet = LineChartDataSet(values: lineDataEntries, label: "BMI")
            chartDataSet.valueTextColor = bmiDataColor
            chartDataSet.circleColors = [bmiDataColor]
            chartDataSet.circleHoleRadius = 2
            chartDataSet.colors = [bmiDataColor]
            chartDataSet.circleRadius = 5.0
            
        let lineData = LineChartData(dataSet: chartDataSet)
        let bmiColor = UIColor(red: 92/255, green: 61/255, blue: 32/255, alpha: 1)
        let description = Description()
            description.text = "\(dataPoints[0]) - \(dataPoints[dataPoints.count - 1])"
            description.textColor = bmiColor
        self.lineChartView.backgroundColor = UIColor.clear
        self.lineChartView.drawGridBackgroundEnabled = true
        self.lineChartView.gridBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)

        
        self.lineChartView.chartDescription = description
        
        let labelText = UIFont(name: "Kohinoor Bangla", size: 10.0)!
            
            
        let chartLimit1 = ChartLimitLine(limit: 24.0, label: "Overweight")
            chartLimit1.valueTextColor = UIColor(red: 255/255, green: 89/255, blue: 63/255, alpha: 1)
            chartLimit1.lineColor = UIColor(red: 255/255, green: 89/255, blue: 63/255, alpha: 1)
            chartLimit1.valueFont = labelText
        let chartLimit2 = ChartLimitLine(limit: 18.5, label: "Underweight")
            chartLimit2.labelPosition = .leftBottom
            chartLimit2.valueTextColor = UIColor(red: 255/255, green: 191/255, blue: 59/255, alpha: 1)
            chartLimit2.lineColor = UIColor(red: 255/255, green: 191/255, blue: 59/255, alpha: 1)
            chartLimit2.valueFont = labelText
        self.lineChartView.rightAxis.addLimitLine(chartLimit1)
        self.lineChartView.rightAxis.addLimitLine(chartLimit2)
        self.lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        self.lineChartView.legend.font = labelText
        self.lineChartView.xAxis.drawLabelsEnabled = true
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.leftAxis.labelTextColor = bmiColor
        self.lineChartView.rightAxis.labelTextColor = bmiColor
        self.lineChartView.xAxis.labelTextColor = bmiColor
        self.lineChartView.legend.textColor = bmiColor
        self.lineChartView.xAxis.granularityEnabled = true
        self.lineChartView.xAxis.granularity = 0.5
        self.lineChartView.leftAxis.axisMinimum = Double(averageData) - 10.0
        self.lineChartView.leftAxis.axisMaximum = Double(averageData) + 10.0
        self.lineChartView.rightAxis.axisMinimum = Double(averageData) - 10.0
        self.lineChartView.rightAxis.axisMaximum = Double(averageData) + 10.0
        self.lineChartView.data = lineData
        
    }
    
    }
}
