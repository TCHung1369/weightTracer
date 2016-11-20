//
//  CoreDataHelper.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 25/10/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import CoreData


class CoreDataHelper: NSObject,NSFetchRequestResult,NSFetchedResultsControllerDelegate {
    
    
    //Store Property
    static var coreDataHelper : CoreDataHelper!
    var fetchResultController : NSFetchedResultsController<WeightData>?
    var fetchPersonController : NSFetchedResultsController<PersonInformation>?
    let dateFomatter = DateFormatter()
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    let moc : NSManagedObjectContext?
    
    //Singlton object
    static func defaultCoreDataHelper() -> CoreDataHelper{
        if coreDataHelper == nil {
         coreDataHelper = CoreDataHelper()
        }
     return coreDataHelper
    }
    
    override init(){
        self.moc = self.appDelegate.persistentContainer.viewContext
    }
    
    // fetchData WeightData
    func fetchWeightData(ascending:Bool) -> [WeightData]{
        
    var weightDatas : [WeightData] = []
    let fetchRequest = NSFetchRequest<WeightData>(entityName: "WeightRecord")
    let sortDescription = NSSortDescriptor(key: "dateData", ascending: ascending)
    fetchRequest.sortDescriptors = [sortDescription]
    self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil)
    self.fetchResultController?.delegate = self
    
        do{
            try self.fetchResultController?.performFetch()
            weightDatas  = self.fetchResultController?.fetchedObjects as [WeightData]!
            
        }catch{print(error)}

        return weightDatas
    }
    
    
    //fetchData PersonalInformation
    func fetchPersonalData() -> [PersonInformation]{
        var personal : [PersonInformation] = []
        let fetchRequest1 = NSFetchRequest<PersonInformation>(entityName: "PersonInformation")
        let sortDescription = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest1.sortDescriptors = [sortDescription]
        self.fetchPersonController = NSFetchedResultsController(fetchRequest: fetchRequest1, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchResultController?.delegate = self
        
        do{
            try self.fetchPersonController?.performFetch()
            personal  = self.fetchPersonController?.fetchedObjects as [PersonInformation]!
            
        }catch{print(error)}
        
        return personal

    
    }
    
    //save data
    public func saveContext(){
     self.appDelegate.saveContext()
    }
}
