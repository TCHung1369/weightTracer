//
//  AddDataViewController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 19/10/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import  CoreData

class AddDataViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

   
    @IBOutlet var myScrollView: UIScrollView!
    @IBOutlet var addImage: UIImageView!
    @IBOutlet var fatRateField: UITextField!
    @IBOutlet var bmiField: UITextField!
    @IBOutlet var weightField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var backgroundView: UIImageView!
    
    
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    var textArray = [UITextField]()
    let dateFomatter = DateFormatter()
    let dateData = Date.init()
    //var coreDataHelper : CoreDataHelper?
    let coreDataHelper = CoreDataHelper.defaultCoreDataHelper()
    var addImageData : UIImage?
    let imagePickerController = UIImagePickerController()
    var heightData : Float?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print(#function)
        self.backgroundView.image = UIImage(named: "bg9")
        textArray = [self.bmiField,self.fatRateField,self.weightField]
        
        
        
        self.heightLabel.text = String(heightData!)
        

        
        self.dateFomatter.dateFormat = "yyyy-MM-dd"
        self.dateField.text = self.dateFomatter.string(from: dateData)
        self.imagePickerController.delegate = self
        
        self.registerKeyboardNotification()
        
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowUp), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardWillShowUp(aNotification:Notification){
        
        let info :Dictionary = aNotification.userInfo!
        let kbSize : NSValue = info["UIKeyboardFrameBeginUserInfoKey"] as! NSValue
        let kbRect = kbSize.cgRectValue.size
        let containEdgeInset : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.height, 0.0)
        self.myScrollView.contentInset = containEdgeInset
        self.myScrollView.scrollIndicatorInsets = containEdgeInset
        
        
    }
    
    func keyboardWillHide(aNotification:Notification){
        let containEdgeInsets = UIEdgeInsets.zero
        self.myScrollView.contentInset = containEdgeInsets
        self.myScrollView.scrollIndicatorInsets = containEdgeInsets
        
    }
    @IBAction func saveData(_ sender: UIButton) {
        if addImage == nil || fatRateField.text == "" || bmiField.text == "" || weightField.text == ""{
            let  alerController = UIAlertController(title: "Notice", message: "Please fill all blank", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alerController.addAction(alertAction)
            self.present(alerController, animated: true, completion: nil)
        }else{
            //let moc = self.coreDataHelper?.moc
            let moc = self.coreDataHelper.moc
            
            let weightData = NSEntityDescription.insertNewObject(forEntityName: "WeightRecord", into:moc! ) as! WeightData
            
            weightData.bmiData = Float(self.bmiField.text!)!
            weightData.fatRate = Float(self.fatRateField.text!)!
            weightData.height = Float(self.heightLabel.text!)!
            weightData.weight = Float(self.weightField.text!)!
            weightData.dateData = self.dateFomatter.date(from: self.dateField.text!)!
            if let image = self.addImage.image{
            weightData.image = UIImageJPEGRepresentation(image, 0.4)!
            }
            
            moc?.insert(weightData)
            
            //self.coreDataHelper?.saveContext()
            self.coreDataHelper.saveContext()
            
            
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        if self.dateField.isFirstResponder{
            self.dateField.resignFirstResponder()
        }
        
        for textField in self.textArray{
            textField.resignFirstResponder()
        }

    }

    @IBAction func userChooseImage(_ sender: UIButton) {
        
        
        let alertViewController = UIAlertController(title: "Notice", message: "How do you choose picture?", preferredStyle: .alert)
        
        let alertAction1 = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true{
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
        
        let alertAction2 = UIAlertAction(title: "Photo Library", style: .default) { (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true{
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
        
        alertViewController.addAction(alertAction1)
        alertViewController.addAction(alertAction2)
        self.present(alertViewController, animated: true, completion: nil)
        
        
}

 
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        if textField.tag == 101 {
            print("\(self.dateField.isFirstResponder)")
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(self.dateChange), for: .valueChanged)
            textField.inputView = datePicker
            datePicker.backgroundColor = UIColor.clear
            
        }
        
    }
    
    func dateChange(_ sender: UIDatePicker){
      dateFomatter.dateFormat = "yyyy-MM-dd"
     self.dateField.text = dateFomatter.string(from: sender.date)
        
    }
    
    @IBAction func calBMI(_ sender: UIButton) {
        
        if self.heightLabel.text == "" || self.weightField.text == ""{
         let alertViewCOntroller = UIAlertController(title: "Notice", message: "please fill height and weight blank", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertViewCOntroller.addAction(alertAction)
            self.present(alertViewCOntroller, animated: true, completion: nil)
        }else{
            let height = (Double(self.heightLabel.text!))! * 0.01
            let weight = Double(self.weightField.text!)
            //float
            let bmiData =  weight! / (height * height)
            var bmiNumber1 = Decimal(bmiData)
            var bmiNumber2 = Decimal()
            NSDecimalRound(&bmiNumber2, &bmiNumber1, 2, .plain)
            let bmiFloat = bmiNumber2.floatValue
            self.bmiField.text = String(bmiFloat)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    

    
    @IBAction func returnTomain(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension AddDataViewController{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        picker.dismiss(animated: true) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            if picker.sourceType == .camera{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            self.addImage.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
     self.dismiss(animated: true, completion: nil)
    }

}


