//
//  IAPHelper.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 14/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import StoreKit

//將String 用 ProductIdentifier 來代替
public typealias ProductIdentifier = String

public typealias ProductsRequestCompletionHandler = (_ success : Bool, _ products: [SKProduct]?) ->()

class IAPHelper: NSObject {
    
    
    fileprivate let productIdentifiers : Set<ProductIdentifier>
    
    fileprivate var purchaseProductIdentifiers = Set<ProductIdentifier>()
    fileprivate var productRequest : SKProductsRequest?
    fileprivate var productRequestCompletionHandler : ProductsRequestCompletionHandler?
    
    
   static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    
    
    // IAPHelper init
    public init(productIDs : Set<ProductIdentifier>){
    productIdentifiers = productIDs
    
        for productIdentifier in productIDs{
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            //判斷是否有購買(利用userdefault)
            if purchased == true{
                purchaseProductIdentifiers.insert(productIdentifier)
                print("Previously purchased:\(productIdentifier)")
            }else{
                print("Not purchased:\(productIdentifier)")
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }

}


//Extension StoreKit

extension IAPHelper{

//Request for the productID
    public func requestProducts(_ completionHandler : @escaping ProductsRequestCompletionHandler){
        self.productRequest?.cancel()
        productRequestCompletionHandler = completionHandler
        //在這裡productRequest初始化
        self.productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        self.productRequest!.delegate = self
        self.productRequest?.start()

    }
    
    public func isProductPurchased(_ productIndentifer : ProductIdentifier) -> Bool{
        
        return self.purchaseProductIdentifiers.contains(productIndentifer)
    }
    
    public func buyProduct(_ product : SKProduct){
        //print("buyProduct : \(product.productIdentifier)")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public class func canMakePayments() -> Bool{
    return SKPaymentQueue.canMakePayments()
    }
    public func restorePurchases(){
    SKPaymentQueue.default().restoreCompletedTransactions()
    }
}


extension IAPHelper : SKProductsRequestDelegate{

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
        let products = response.products
        self.productRequestCompletionHandler?(true,products)
        
        clearRequestAndHandler()


    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("request error")
        print("\(error.localizedDescription)")
        self.productRequestCompletionHandler?(false,nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler(){
     self.productRequest = nil
     self.productRequestCompletionHandler = nil
    }
    
}

extension IAPHelper : SKPaymentTransactionObserver {
    
    private func deliverPurchaseNotificationFor(identifier : String?){
        guard let identifier = identifier else {
            return
        }
        purchaseProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: Notification.Name.init(IAPHelper.IAPHelperPurchaseNotification), object: identifier)
        
    }
    
    private func complete(_ transaction : SKPaymentTransaction){
    print("Complete")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(_ transaction : SKPaymentTransaction){
        guard let productionIdentifier = transaction.original?.payment.productIdentifier else {return}
        //print("\(productionIdentifier)")
        print("restore : \(productionIdentifier)")
        deliverPurchaseNotificationFor(identifier: productionIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func failed(_ transaction: SKPaymentTransaction){
    print("fail")
        if let transcationError = transaction.error as? NSError{
            if transcationError.code != SKError.paymentCancelled.rawValue{
                 print("Transaction Error : \(transaction.error?.localizedDescription)")
            }
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]){

        for transaction in transactions {
            switch (transaction.transactionState){
            case .purchased:
                complete(transaction)
                 break
            case .restored:
                restore(transaction)
                 break
            case .failed:
                failed(transaction)
                break
            case .purchasing:
                break
            default:
                 break
        
            }
        }
        
    }

    
    //private func
    
    
    
}
