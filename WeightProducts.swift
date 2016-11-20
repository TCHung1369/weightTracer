//
//  WeightProducts.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 14/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import StoreKit

class WeightProducts: NSObject {
    
    public static let chartFunctionIAP = "Tzu_Chen_WeightRecorder_ChartFunction"
    fileprivate static var productIndentifers : Set<ProductIdentifier> = [WeightProducts.chartFunctionIAP]
    public static let store = IAPHelper(productIDs: WeightProducts.productIndentifers)
}
