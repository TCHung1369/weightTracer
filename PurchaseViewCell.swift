//
//  PurchaseViewCell.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 14/11/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewCell: UITableViewCell {

    @IBOutlet var productDescription: UILabel!
    @IBOutlet var productTitle: UILabel!
    
    static let priceFomatter = { () -> NumberFormatter in 
    let formatter = NumberFormatter()
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
        return formatter
    }()
    
    var buyButtonHandler : ((_ product : SKProduct) -> ())?
    
    var product : SKProduct? {
        didSet{
        guard let product = product else { return }
            if WeightProducts.store.isProductPurchased(product.productIdentifier){
            accessoryType = .checkmark
            accessoryView = nil
            productDescription.text = ""
                
            }else if IAPHelper.canMakePayments(){
                
                PurchaseViewCell.priceFomatter.locale = product.priceLocale
                self.productDescription.text = PurchaseViewCell.priceFomatter.string(from: product.price)
                accessoryType = .none
                accessoryView = newBuyButton()
                
            }else{
                self.productDescription.text = "Not available"
            }
        }
    }
    
    func newBuyButton() -> UIButton{
    let buyButton = UIButton(type: .system)
        buyButton.setTitleColor(tintColor, for: UIControlState())
        buyButton.setTitle("Buy", for: UIControlState())
        buyButton.addTarget(self, action: #selector(PurchaseViewCell.tapBuyButton), for: .touchUpInside)
        buyButton.sizeToFit()
        return buyButton
    }
    
    func tapBuyButton(){
        self.buyButtonHandler?(product!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
