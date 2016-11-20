//
//  PageViewController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 11/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController,UIPageViewControllerDataSource {

    var pageTitles :[String] = ["Step1. Setting Personal Info.", "Step2. Add Weight Record","Step3. Share and Delete", "Step4. Analysis by the Chart!"]
    var imageNames :[String] = ["intro-1","intro-2","intro-3","intro-4"]
    var contentTexts : [String] = [" Setting personal info. before Add weight data "," Add image,weight,body fat and date", " Share on FaceBook or Twitter ", " All data show by the Chart!! Free trial for 20 times "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let startViewController = viewControllerAtIndex(index: 0){
            self.setViewControllers([startViewController], direction: .forward, animated: true, completion: nil)
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //setting content
    func viewControllerAtIndex(index : Int) -> IntroViewController?{
        if index == NSNotFound || index < 0 || index >= pageTitles.count{
            return nil
        }
        
        if let introViewController = self.storyboard?.instantiateViewController(withIdentifier: "introViewController") as? IntroViewController{
            introViewController.contentText = self.contentTexts[index]
            introViewController.contentImage = self.imageNames[index]
            introViewController.index = index
            introViewController.headingText = self.pageTitles[index]
            return introViewController
        }
        
        return nil
    }
    

    
    
}

extension PageViewController{

    @objc(pageViewController:viewControllerBeforeViewController:) func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        
        var index = (viewController as! IntroViewController).index
        
        index -= 1
        return viewControllerAtIndex(index: index)
    }

    @objc(pageViewController:viewControllerAfterViewController:) func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        
        var index = (viewController as! IntroViewController).index
        
        index += 1
        return viewControllerAtIndex(index: index)
    }
}



