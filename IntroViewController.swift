//
//  IntroViewController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 11/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var introBackImageView: UIImageView!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var introImage: UIImageView!
    
    @IBOutlet var myPageControl: UIPageControl!
    
    var index = 0
    var headingText = ""
    var contentImage = ""
    var contentText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.introBackImageView.bounds
        self.introBackImageView.addSubview(visualEffectView)

        self.myPageControl.currentPage = index
        self.titleLabel.text = headingText
        self.contentLabel.text = contentText
        self.introImage.image = UIImage(named: contentImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitPress(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isTutrial")
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
