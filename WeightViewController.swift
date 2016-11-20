//
//  WeightViewController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 03/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import Charts

class WeightViewController: UIViewController {

    @IBOutlet var lineChartView: LineChartView!
    
    @IBOutlet var myImageView: UIImageView!
    let coreDataHelper = CoreDataHelper()
    var weightDatas : [WeightData] = []
    let dateFomatter = DateFormatter()
    var weightArray = [Double]()
    var dateArray = [String]()
    var highWeight : Double?
    var lowWeight : Double?
    var personalHeight : Float?
    var personInformation : [PersonInformation] = []
    
    @IBOutlet var heightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarController = self.tabBarController as! TabBarController
        self.personInformation = tabBarController.personalInformation
        self.weightDatas = tabBarController.weightDatas
        //Float
        self.personalHeight = self.personInformation.last?.height
        
        self.dateFomatter.dateFormat = "MM-dd"
        
        
        for i in 0..<self.weightDatas.count{
            let weightData = self.weightDatas[i].weight
            let dateData = self.dateFomatter.string(from: self.weightDatas[i].dateData)
            self.weightArray.append(Double(weightData))
            self.dateArray.append(dateData)
        }
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.bounds
        self.myImageView.addSubview(visualEffectView)
        
        
        if self.weightDatas.count <= 1{
            self.lineChartView.noDataText = "Please provide two datas at least"
        }else{
            
           // let myHeightData = Double(self.weightDatas[0].height) * 0.01
            let myHeightData = Double(self.personalHeight!) * 0.01
            self.highWeight = 24.0 * myHeightData * myHeightData
            self.lowWeight = 18.5 * myHeightData * myHeightData
            self.heightLabel.text = "According to: \(self.personalHeight!) cm, ideal weight range : \(Int(self.highWeight!))-\(Int(self.lowWeight!)) kg"
            self.setChart(dataPoints: self.dateArray, values: self.weightArray)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
 }


extension WeightViewController{
    //Setting Chart Data
    func setChart(dataPoints:[String],values:[Double]){
        
        if dataPoints == [] || values == []{
            self.lineChartView.noDataText = "Please provide two datas at least"
        }else{
            
            let weightColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            let weightDataColor = UIColor(red: 0/255, green: 128/255, blue: 64/255, alpha: 1)
            
            
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
            averageData = Int(Int(sumData) / values.count)
            xaxis.valueFormatter = lineChartFormatter
            let chartDataSet = LineChartDataSet(values: lineDataEntries, label: "Weight")
            chartDataSet.valueTextColor = weightDataColor
            chartDataSet.circleColors = [weightDataColor]
            chartDataSet.circleHoleRadius = 2
            chartDataSet.colors = [weightDataColor]
            
            chartDataSet.circleRadius = 5.0
            let description = Description()
            description.text = "\(dataPoints[0]) - \(dataPoints[dataPoints.count - 1])"
            description.textColor = weightColor
            let labelText = UIFont(name: "Kohinoor Bangla", size: 10.0)!
            let lineData = LineChartData(dataSet: chartDataSet)
            let highLimit = self.highWeight!
            let lowLimit = self.lowWeight!
            
            let chartLimit1 = ChartLimitLine(limit: highLimit, label: "Overweight")
            chartLimit1.valueTextColor = UIColor(red: 255/255, green: 89/255, blue: 63/255, alpha: 1)
            chartLimit1.lineColor = UIColor(red: 255/255, green: 89/255, blue: 63/255, alpha: 1)
            chartLimit1.valueFont = labelText
            let chartLimit2 = ChartLimitLine(limit: lowLimit, label: "Underweight")
            chartLimit2.labelPosition = .leftBottom
            chartLimit2.valueTextColor = UIColor(red: 255/255, green: 191/255, blue: 59/255, alpha: 1)
            chartLimit2.lineColor = UIColor(red: 255/255, green: 191/255, blue: 59/255, alpha: 1)
            chartLimit2.valueFont = labelText
            
            self.lineChartView.rightAxis.addLimitLine(chartLimit1)
            self.lineChartView.rightAxis.addLimitLine(chartLimit2)
            self.lineChartView.chartDescription = description
            self.lineChartView.legend.textColor = weightColor
             self.lineChartView.drawGridBackgroundEnabled = true
            self.lineChartView.gridBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
            self.lineChartView.backgroundColor = UIColor.clear
            self.lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
            self.lineChartView.xAxis.drawLabelsEnabled = true
            self.lineChartView.xAxis.labelPosition = .bottom
            self.lineChartView.xAxis.granularityEnabled = true
            self.lineChartView.xAxis.granularity = 0.5
            self.lineChartView.leftAxis.axisMinimum = Double(averageData) - 40.0
            self.lineChartView.leftAxis.axisMaximum = Double(averageData) + 40.0
            self.lineChartView.chartDescription = description
            self.lineChartView.rightAxis.axisMinimum = Double(averageData) - 40.0
            self.lineChartView.rightAxis.axisMaximum = Double(averageData) + 40.0
            self.lineChartView.rightAxis.labelTextColor = weightColor
            self.lineChartView.leftAxis.labelTextColor = weightColor
            self.lineChartView.xAxis.labelTextColor = weightColor
            self.lineChartView.data = lineData
            
        }
        
    }





}

