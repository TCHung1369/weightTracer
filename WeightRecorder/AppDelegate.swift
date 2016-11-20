//
//  AppDelegate.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 19/10/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont(name: "Kohinoor Bangla", size: 10.0)!],for: UIControlState.normal)
        
       
        
        
        UIApplication.shared.isStatusBarHidden = true
        
        if (UserDefaults.standard.object(forKey: "chartTap") == nil){
            UserDefaults.standard.set(20, forKey: "chartTap")
        }
        
        if (UserDefaults.standard.object(forKey: "Tzu_Chen_WeightRecorder_ChartFunction") == nil){
        UserDefaults.standard.set(false, forKey: "Tzu_Chen_WeightRecorder_ChartFunction")
        }        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
      
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack
//    lazy var applicationDocumentsDirectory : URL = {
//    let urls = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)
//        return urls[urls.count - 1]
//    }()
//    
//    lazy var managedObjectModel : NSManagedObjectModel = {
//    let modelURL = Bundle.main.url(forResource: "WeightRecorder", withExtension: "momd")!
//        return NSManagedObjectModel(modelURL)
//    }()
//    
    
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "WeightRecorder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
//
//    lazy var managedObjectContext : NSManagedObjectContext = {
//        let coordinator : NSPersistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
//        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//    }()
    
    // MARK: - Core Data Saving support

    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("save ok")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

