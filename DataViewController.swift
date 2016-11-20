//
//  DataViewController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 19/10/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import CoreData


class DataViewController: UIViewController,UICollectionViewDataSource,NSFetchedResultsControllerDelegate,NSFetchRequestResult,UICollectionViewDelegate,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var snowImage: UIImageView!
    @IBOutlet var myColloectionView : UICollectionView!
    
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let dateFomatter = DateFormatter()
    let dateData = Date()
    var fetchResultController : NSFetchedResultsController<WeightData>?
    var weightDatas : [WeightData] = []
    var blockOperations:[BlockOperation] = []
    var coreDataHelper = CoreDataHelper.defaultCoreDataHelper()
   
    
    //Setting Personal Property
    var isMale : Bool?
    var personalAge : Int?
    var personalHeight : Float?
    var bodyFatTarget : Float?
    var personalDatas:[PersonInformation] = []
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dateFomatter.dateFormat = "yyyy-MM-dd"
        
        //setting fetchController
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
        
        //judge self.personalDatas是否有資料
        if self.personalDatas == [] {
            return
        }else{
            isMale = self.personalDatas.last?.gender
            personalAge = Int((self.personalDatas.last?.age)!)
            personalHeight = self.personalDatas.last?.height
            bodyFatTarget = self.personalDatas.last?.target
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let blurEffect = UIBlurEffect(style: .light)
       let visualEffectView = UIVisualEffectView(effect: blurEffect)
       visualEffectView.frame = self.snowImage.bounds
        self.snowImage.addSubview(visualEffectView)
        self.myColloectionView.layer.cornerRadius = 10
        self.myColloectionView.layer.masksToBounds = true
        self.myColloectionView.backgroundColor = UIColor.clear
        self.personalDatas = self.coreDataHelper.fetchPersonalData()
       
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if self.weightDatas.count == 0 {
         return 0
        }else{
        return self.weightDatas.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as! MyCollectionViewCell
        
        let imageView = UIImageView(image: UIImage(named: "bg1"))
        
        cell.fatRate.text = String(self.weightDatas[indexPath.row].fatRate)
        cell.myBMI.text = String(self.weightDatas[indexPath.row].bmiData)
        cell.myHeight.text = String(self.weightDatas[indexPath.row].height)
        cell.myWeight.text = String(self.weightDatas[indexPath.row].weight)
        cell.myImageView.image = UIImage(data: self.weightDatas[indexPath.row].image)
        cell.myImageView.layer.cornerRadius = 10.0
        cell.myImageView.layer.masksToBounds = true
        cell.backgroundView = imageView
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.recordDate.text = self.dateFomatter.string(from: self.weightDatas[indexPath.row].dateData)
        
        return cell
    }

    @IBAction func userExit(_ sender:UIStoryboardSegue){
    
    }

    //transfor data by segue
    @IBAction func goAddData(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addData", sender: self)
    }
    
    
    //PopSettingView
    @IBAction func userPopController(_ sender: UIButton) {
        self.performSegue(withIdentifier: "popView", sender: self)
        
    }
    
    @IBAction func userGoCHart(_ sender: UIButton) {
        
        //fetch IAP oand tapNumber
        let chartIAP = UserDefaults.standard.object(forKey: "Tzu_Chen_WeightRecorder_ChartFunction") as! Bool
        print("ProductionID isBuy : \(chartIAP)")
        
       var tapNumber = UserDefaults.standard.object(forKey: "chartTap") as! Int
        print("Test Number : \(tapNumber)")
        
        
        if tapNumber > 0{
            //Still in Trail
            if self.personalDatas == []{
                let alertController = UIAlertController(title: "Notice", message: "Please add personal information first", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
               //Jump out of function
                return
            }
            
            
        tapNumber -= 1
        UserDefaults.standard.set(tapNumber, forKey: "chartTap")
        self.performSegue(withIdentifier: "goTabBar", sender: self)
            
            
        }else if (chartIAP == true){
            
            
            if self.personalDatas == []{
                let alertController = UIAlertController(title: "Notice", message: "Please add personal information first", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                //Jump out of function
                return
            }
            
            self.performSegue(withIdentifier: "goTabBar", sender: self)
            
        }else if (tapNumber == 0 && chartIAP == false){
            
        tapNumber = 0
            
        UserDefaults.standard.set(tapNumber, forKey: "chartTap")
            print("present iap conttroller")
            let alertController = UIAlertController(title: "Notice", message: "Your trial got limited, if you like chart function, please go to IAP and get permission !", preferredStyle: .alert)
            
            let alertAction1 = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                let iapNaviController = self.storyboard?.instantiateViewController(withIdentifier: "IAPNavi") as! UINavigationController
                self.present(iapNaviController, animated: true, completion: nil)
            })
            
            let alertAction2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(alertAction1)
            alertController.addAction(alertAction2)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "popView"{
         let popController = segue.destination as! PopViewController
            popController.preferredContentSize = CGSize(width: 200, height: 250)
            let controller = popController.popoverPresentationController
            if controller != nil{
            controller?.delegate = self
            }
        }
        
        if segue.identifier == "addData" {
            
            
            self.personalDatas = self.coreDataHelper.fetchPersonalData()
            
            if self.personalDatas == []{
                let alertController = UIAlertController(title: "Notice", message: "Please add personal information first", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                let addViewController = segue.destination as! AddDataViewController
                personalHeight = self.personalDatas.last?.height
                addViewController.heightData = self.personalHeight!
                self.present(addViewController, animated: true, completion: nil)
            }
        }
        
        if segue.identifier == "goTabBar"{
            
            self.personalDatas = self.coreDataHelper.fetchPersonalData()
            if self.personalDatas == []{
                let alertController = UIAlertController(title: "Notice", message: "Please add personal information first", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                
            let tabBarController = segue.destination as! TabBarController
            self.present(tabBarController, animated: true, completion: nil)
            
            
            }
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}




 // CollectionView Controller delegate
extension DataViewController{

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
       blockOperations.removeAll(keepingCapacity: false)
    }

    @objc(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:) func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        
        switch type {
        case .insert:
            print("Insert")
         blockOperations.append(BlockOperation(block: {
            [weak self] in
            if let this = self{
            this.myColloectionView.insertItems(at: [newIndexPath!])
            }
         })
            )
        
        case .delete:
           // print("delete")
            blockOperations.append(BlockOperation(block: {
                [weak self] in
                if let this = self{
                    this.myColloectionView.deleteItems(at: [indexPath!])
                }
                })
            )
        case .update:
            
            blockOperations.append(BlockOperation(block: {
                [weak self] in
                if let this = self{
                    this.myColloectionView.reloadItems(at: [newIndexPath!])
                }
                })
            )
        default:
            blockOperations.append(BlockOperation(block: {
                [weak self] in
                if let this = self{
                    this.myColloectionView.reloadItems(at: [newIndexPath!])
                }
                })
            )
        }

       
        self.weightDatas = self.coreDataHelper.fetchWeightData(ascending: false)
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.myColloectionView.performBatchUpdates({ 
            for operationBlock : BlockOperation in self.blockOperations{
             operationBlock.start()
            }
            }) { (finialed) in
                self.blockOperations.removeAll(keepingCapacity: false)
        }
    }

    
   
}


