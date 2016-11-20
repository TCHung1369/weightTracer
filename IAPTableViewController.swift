//
//  IAPTableViewController.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 14/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import StoreKit

class IAPTableViewController: UITableViewController {

    
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "In-App Purchase"
        let leftBarButton = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(userDismiss))
        let rightBarButton = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(userRestore))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlerPurchasedNotification), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
        
        
    }

    func userDismiss(){
    self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
    }
    
    func userRestore(){
        WeightProducts.store.restorePurchases()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func reload(){
    self.products = []
        self.tableView.reloadData()
        
        WeightProducts.store.requestProducts { (success, products) in
            
            if success {
            self.products = products!
            self.tableView.reloadData()
                
            }
        }
    
    }
    
    func handlerPurchasedNotification(_ notification:Notification){
    guard let productID = notification.object as? String else { return }
        
        for(index , product) in products.enumerated(){
            guard product.productIdentifier == productID else { continue }
            
            self.tableView.reloadRows(at: [IndexPath(row:index,section : 0)], with: .fade)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.products.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! PurchaseViewCell
        cell.productTitle.text = self.products[indexPath.row].localizedDescription
        //cell.productDescription.text = self.products[indexPath.row].localizedTitle
        let product = products[indexPath.row]
        cell.product = product
        
        cell.buyButtonHandler = {
        (product) -> Void in
            WeightProducts.store.buyProduct(product)
        }
        
        
        return cell
    }
    

 
}
