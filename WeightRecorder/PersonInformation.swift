//
//  PersonInformation.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 07/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import CoreData

class PersonInformation: NSManagedObject {
    @NSManaged var age:Float
    @NSManaged var gender:Bool
    @NSManaged var height:Float
    @NSManaged var target:Float
    @NSManaged var date : Date
}
