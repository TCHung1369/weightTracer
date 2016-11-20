//
//  PopViewController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 07/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import CoreData

class PopViewController: UIViewController,UITextFieldDelegate {

    //Trans infromation
    var delegate : PopViewControllerDelegate?
    var isMale : Bool?
    var personalAge : Int?
    var personalHeight : Float?
    var bodyFatTarget : Float?
    
    //Class property
    @IBOutlet var addBackgroundImage: UIImageView!
    @IBOutlet var ageField: UITextField!
    @IBOutlet var bodyFatField: UITextField!
    @IBOutlet var heightField: UITextField!
    
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    
    let coreDataHelper = CoreDataHelper.defaultCoreDataHelper()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.maleButton.setImage( UIImage(named: "selectedman"), for: .selected)
         self.femaleButton.setImage(UIImage(named: "selectedwomen"), for: .selected)
                let blurEffect = UIBlurEffect(style: .light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = self.addBackgroundImage.bounds
                self.addBackgroundImage.addSubview(blurEffectView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func maleAction(_ sender: UIButton) {
        self.isMale = true
        sender.isSelected = true
        if self.femaleButton.state == .selected{
        self.femaleButton.isSelected = false
        }

    }

    @IBAction func femaleAction(_ sender: UIButton) {
        self.isMale = false
        
        sender.isSelected = true
        
        if self.maleButton.state == .selected{
            self.maleButton.isSelected = false
        }
    }
  
    @IBAction func saveSetting(_ sender: UIButton) {
    
        if ageField.text == "" || heightField.text == "" || bodyFatField.text == "" || isMale == nil {
            let alertController = UIAlertController(title: "Notice", message: "Please fill blank with correct value", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            
        //save personal information
       let dateData = Date.init()
       let ageInt = Int(ageField.text!)
       let heightFloat = Float(heightField.text!)
       let bodyFatFloat = Float(bodyFatField.text!)
        let moc = coreDataHelper.moc
         let informationData = NSEntityDescription.insertNewObject(forEntityName: "PersonInformation", into:moc! ) as! PersonInformation
            
          informationData.age = Float(ageInt!)
          informationData.gender = self.isMale!
          informationData.height = heightFloat!
          informationData.target = bodyFatFloat!
          informationData.date = dateData
            
         moc?.insert(informationData)
         coreDataHelper.saveContext()
        
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}

protocol PopViewControllerDelegate : class {
    func savePersonalSetting(height:Float ,target:Float ,age:Int, gender:Bool)
    
    
    
}
