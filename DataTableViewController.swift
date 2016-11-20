//
//  DataTableViewController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 26/10/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import CoreData
import Social

class DataTableViewController: UITableViewController,NSFetchRequestResult,NSFetchedResultsControllerDelegate {

    
    let coreDataHelper = CoreDataHelper.defaultCoreDataHelper()
    
    var fetchResultController : NSFetchedResultsController<WeightData>?
    var weightDatas : [WeightData] = []
    let dateFomatter = DateFormatter()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest<WeightData>(entityName: "WeightRecord")
        let sortDescription = NSSortDescriptor(key: "dateData", ascending: false)
        fetchRequest.sortDescriptors = [sortDescription]
        let moc = self.coreDataHelper.moc
        
        self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchResultController?.delegate = self
        
        do{
            try self.fetchResultController?.performFetch()
            self.weightDatas = self.fetchResultController?.fetchedObjects as [WeightData]!
            
        }catch{print(error)}

        self.dateFomatter.dateFormat = "yyyy-MM-dd"

        
    }
    
    @IBAction func exitButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backImageView = UIImageView(image: UIImage(named: "bg10"))
        backImageView.frame = self.tableView.bounds
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backImageView.frame
        
        backImageView.addSubview(blurEffectView)
        
        self.tableView.backgroundView = backImageView
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.weightDatas.count == 0 {
            return 0
        }else{
            return self.weightDatas.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! CustomTableViewCell
        
        cell.cellFatRate.text = String(self.weightDatas[indexPath.row].fatRate)
        cell.cellWeight.text = String(self.weightDatas[indexPath.row].weight)
        cell.cellImageView.image = UIImage(data: self.weightDatas[indexPath.row].image)
        cell.textLabel?.font = UIFont(name: "Kohinoor Bangla", size: 18.0)
        cell.backgroundColor = UIColor.clear
        cell.cellDate.text = self.dateFomatter.string(from: self.weightDatas[indexPath.row].dateData)
        return cell
    }
    
    
    //Mark: - TableAction
   override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
    
    let shareAction = UITableViewRowAction(style: .default, title: "Share") { (rowAction, indexPath) in
        
        
      let defaultText = "Come and See my record@WeightReocrder App"
        
      let shareActionController = UIAlertController(title: nil, message: "Please choose Platform!", preferredStyle: .actionSheet)
    
        let twitterAction = UIAlertAction(title: "Twitter", style: .default, handler: {(action) -> Void in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                
             let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
              tweetComposer?.setInitialText(defaultText)
              tweetComposer?.add(UIImage(data: self.weightDatas[indexPath.row].image))
              self.present(tweetComposer!, animated: true
                , completion: nil)
            }else{
             let alertController = UIAlertController(title: "Twitter isn't loggin'", message: "Please go to setting -> Twitter and login your account.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
        
        
        let faceBookAction = UIAlertAction(title: "FaceBook", style: .default, handler:{(action)-> Void in
         
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                
                let faceBookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                faceBookComposer?.setInitialText(defaultText)
                faceBookComposer?.add(UIImage(data: self.weightDatas[indexPath.row].image))
                self.present(faceBookComposer!, animated: true
                    , completion: nil)
            }else{
                let alertController = UIAlertController(title: "FaceBook isn't loggin'", message: "Please go to setting -> FaceBook and login your account.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
        
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
        
        
    shareActionController.addAction(twitterAction)
    shareActionController.addAction(faceBookAction)
    shareActionController.addAction(cancelAction)
    self.present(shareActionController, animated: true, completion: nil)
    
    }
    
    
    
    
     let tableViewRowAction = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
        
        let alertController = UIAlertController(title: "Notice", message: "Are you going to delete this record?", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Sure", style: .default, handler: { (alertaction) in
            let moc = self.coreDataHelper.moc!
            
            let deleteWeightData = self.fetchResultController?.object(at: indexPath) as WeightData!
            
           
            
            moc.delete(deleteWeightData!)
            
            self.coreDataHelper.saveContext()
  
        })
        
        let alertAction2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        alertController.addAction(alertAction2)
        
        self.present(alertController, animated: true, completion: nil)
        }
    
    
    
    
    tableViewRowAction.backgroundColor = UIColor(red: 255/255, green: 26/255, blue: 130/255, alpha: 1)
    
    shareAction.backgroundColor = UIColor(red: 26/255, green: 166/255, blue: 255/255, alpha: 1)
    
        return [tableViewRowAction,shareAction]
    }
    
}



extension DataTableViewController{

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
      self.tableView.beginUpdates()
    }

    
    @objc(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:) func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
    
        switch type {
        case .delete:
            if let indexPath = indexPath{
             self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .insert :
            if let newIndexPath = newIndexPath{
            self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .update:
            if let newIndexPath = newIndexPath{
             self.tableView.reloadRows(at: [newIndexPath], with: .fade)
            }
        default:
            self.tableView.reloadData()
        }
        self.weightDatas = self.fetchResultController?.fetchedObjects as [WeightData]!
       
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
     self.tableView.endUpdates()
    }
}
