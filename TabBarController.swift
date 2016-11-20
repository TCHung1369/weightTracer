//
//  TabBarController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 03/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    let coreDataHelper = CoreDataHelper.defaultCoreDataHelper()
    var weightDatas : [WeightData] = []
    var personalInformation : [PersonInformation] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.barTintColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 0.1)
        self.personalInformation = self.coreDataHelper.fetchPersonalData()
        self.weightDatas = self.coreDataHelper.fetchWeightData(ascending: true)
   
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    }
