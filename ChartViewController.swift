//
//  ChartViewController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 02/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ChartViewController: UIViewController,NSFetchRequestResult,NSFetchedResultsControllerDelegate {

    @IBOutlet var chartLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var lineChartView: LineChartView!
    let coreDataHelper = CoreDataHelper()
    var fetchResultController : NSFetchedResultsController<WeightData>?
    var weightDatas : [WeightData] = []
    var personInformation : [PersonInformation] = []
    let dateFomatter = DateFormatter()
    
    var fatRateArray = [Double]()
    var dateArray = [String]()
    var personAge : Int?
    var personGender : Bool?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarController = self.tabBarController as! TabBarController
        self.weightDatas = tabBarController.weightDatas
        self.personInformation = tabBarController.personalInformation
        self.personAge = Int((self.personInformation.last?.age)!)
        self.personGender = self.personInformation.last?.gender
        self.dateFomatter.dateFormat = "MM-dd"
        
        for i in 0..<self.weightDatas.count{
            let fatData = self.weightDatas[i].fatRate
            let dateData = self.dateFomatter.string(from: self.weightDatas[i].dateData)
            self.fatRateArray.append(Double(fatData))
            self.dateArray.append(dateData)
        }
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.bounds
        self.myImageView.addSubview(visualEffectView)
        
        if self.weightDatas.count <= 1{
            self.lineChartView.noDataText = "Please provide two datas at least"
        }else{
        self.setChart(dataPoints: self.dateArray, values: self.fatRateArray)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func exit(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }

    //judge age
    func bodyFatStandizer(age : Int , isMale : Bool) -> [ChartLimitLine] {
        
        
        let highChartLimit = ChartLimitLine()
        let lowChartLimit = ChartLimitLine()
        highChartLimit.lineColor = UIColor(red: 255/255, green: 89/255, blue: 63/255, alpha: 1)
        highChartLimit.valueTextColor = UIColor(red: 255/255, green: 89/255, blue: 63/255, alpha: 1)
        highChartLimit.label = "High Body Fat"
        highChartLimit.valueFont = UIFont(name: "Kohinoor Bangla", size: 10.0)!
        
        lowChartLimit.lineColor = UIColor(red: 255/255, green: 191/255, blue: 59/255, alpha: 1)
        lowChartLimit.valueTextColor = UIColor(red: 255/255, green: 191/255, blue: 59/255, alpha: 1)
        lowChartLimit.label = "low Body Fat"
        lowChartLimit.valueFont = UIFont(name: "Kohinoor Bangla", size: 10.0)!
        lowChartLimit.labelPosition = .leftBottom
     
        switch (age, isMale) {
        case (0...19,true) :
            highChartLimit.limit = 22.0
            lowChartLimit.limit = 17.1
            self.chartLabel.text = "Gender : Male, Age : \(age), normal body fat is 17.1% - 22.0%"
        case (20...29,true) :
            highChartLimit.limit = 23.0
            lowChartLimit.limit = 18.1
            self.chartLabel.text = "Gender : Male, Age : \(age), normal body fat is 18.1% - 23.0%"
        case (30...39,true) :
            highChartLimit.limit = 24.0
            lowChartLimit.limit = 19.1
            self.chartLabel.text = "Gender : Male, Age : \(age), normal body fat is 19.1% - 24.0%"
        case (40...49,true) :
            highChartLimit.limit = 25.0
            lowChartLimit.limit = 20.1
            self.chartLabel.text = "Gender : Male, Age : \(age), normal body fat is 20.1% - 25.0%"
        case (_,true) :
            highChartLimit.limit = 26.0
            lowChartLimit.limit = 21.1
             self.chartLabel.text = "Gender : Male, Age : \(age), normal body fat is 21.1% - 26.0%"
        case (0...19,false) :
            highChartLimit.limit = 27.0
            lowChartLimit.limit = 22.1
            self.chartLabel.text = "Gender : Female, Age : \(age), normal body fat is 22.1% - 27.0%"
        case (20...29,false) :
            highChartLimit.limit = 28.0
            lowChartLimit.limit = 23.1
            self.chartLabel.text = "Gender : Female, Age : \(age), normal body fat is 23.1% - 28.0%"
        case (30...39,false) :
            highChartLimit.limit = 29.0
            lowChartLimit.limit = 24.1
            self.chartLabel.text = "Gender : Female, Age : \(age), normal body fat is 24.1% - 29.0%"
        case (40...49,false) :
            highChartLimit.limit = 30.0
            lowChartLimit.limit = 25.1
            self.chartLabel.text = "Gender : Female, Age : \(age), normal body fat is 25.1% - 30.0%"
        case (_,false) :
            highChartLimit.limit = 31.0
            lowChartLimit.limit = 26.1
            self.chartLabel.text = "Gender : Female, Age : \(age), normal body fat is 26.1% - 31.0%"
       
        }
        
        return [highChartLimit, lowChartLimit]
    }
   
    
    
    
    
}


extension ChartViewController{
    
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
        averageData = Int(Int(sumData) / values.count)
            
            
        xaxis.valueFormatter = lineChartFormatter
            
        //setup ChartData
        let chartDataSet = LineChartDataSet(values: lineDataEntries, label: "Body fat %")
        let fatRateColor = UIColor(red: 34.0/255.0, green: 197.0/255.0, blue: 255.0/255.0, alpha: 1)
        //let fatRateColor1 = UIColor.blue
        chartDataSet.valueTextColor = fatRateColor
        chartDataSet.circleColors = [fatRateColor]
        chartDataSet.circleHoleRadius = 2
        chartDataSet.colors = [fatRateColor]
        chartDataSet.circleRadius = 5.0
    
            
        let lineData = LineChartData(dataSet: chartDataSet)
        let description = Description()
            
        description.text = "\(dataPoints[0]) - \(dataPoints[dataPoints.count - 1])"
        description.textColor = UIColor.white
        let bodyFatTarget = self.personInformation.last?.target
            
        let chartLimit1 = ChartLimitLine(limit: Double(bodyFatTarget!), label: "Target: \(bodyFatTarget!) %")
            chartLimit1.valueTextColor = UIColor(red: 128/255, green: 225/255, blue: 34/255, alpha: 1)
            chartLimit1.labelPosition = .leftBottom
            chartLimit1.lineColor = UIColor(red: 128/255, green: 225/255, blue: 34/255, alpha: 1)
            chartLimit1.valueFont = UIFont(name: "Kohinoor Bangla", size: 10.0)!
            
            
        let bodyFatArrat = bodyFatStandizer(age: self.personAge!,isMale:  self.personGender!)
        let highlimit = bodyFatArrat[0]
        let lowlimit = bodyFatArrat[1]
        
        self.lineChartView.rightAxis.addLimitLine(highlimit)
         self.lineChartView.rightAxis.addLimitLine(lowlimit)
        self.lineChartView.rightAxis.addLimitLine(chartLimit1)
        self.lineChartView.backgroundColor = UIColor.clear
        self.lineChartView.drawGridBackgroundEnabled = true
        self.lineChartView.gridBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        self.lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        self.lineChartView.xAxis.drawLabelsEnabled = true
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.chartDescription = description
        self.lineChartView.xAxis.granularityEnabled = true
        self.lineChartView.xAxis.granularity = 0.5
        self.lineChartView.leftAxis.axisMinimum = 0.0
        self.lineChartView.leftAxis.axisMaximum = Double(averageData) + 20.0
        self.lineChartView.rightAxis.axisMinimum = 0.0
        self.lineChartView.rightAxis.axisMaximum = Double(averageData) + 20.0
        self.lineChartView.legend.font = UIFont(name: "Kohinoor Bangla", size: 10.0)!
        self.lineChartView.legend.textColor = UIColor.white
        self.lineChartView.xAxis.labelTextColor = UIColor.white
        self.lineChartView.leftAxis.labelTextColor = UIColor.white
        self.lineChartView.rightAxis.labelTextColor = UIColor.white
        self.lineChartView.data = lineData
        
    }
    
    }



}


