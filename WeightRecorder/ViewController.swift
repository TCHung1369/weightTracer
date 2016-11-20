//
//  ViewController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 19/10/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit


class ViewController: UIViewController{

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var startButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if !(UserDefaults.standard.object(forKey: "isTutrial") != nil) {
            UserDefaults.standard.set(false, forKey: "isTutrial")
        }
        UIView.animate(withDuration: 4, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {self.iconImageView.alpha = 1 }, completion: nil)
        
        
    
    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let tutrialBool = UserDefaults.standard.object(forKey: "isTutrial") as! Bool
        if tutrialBool == false{
            let pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "goIntroPage") as? PageViewController
            self.present(pageViewController!, animated: true, completion: nil)
        }
        
  
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//goIntroPage
    @IBAction func startWeightRecorder(_ sender: UIButton) {
         //UserDefaults.standard.set(false, forKey: "isTutrial")
         self.performSegue(withIdentifier: "goCollectionView", sender: self)
        
    }
    
}

extension Decimal{
    var floatValue : Float{
        return NSDecimalNumber(decimal: self).floatValue
    }
}
