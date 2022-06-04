//
//  SupportUsViewController.swift
//  The 92
//
//  Created by Daniel Earl on 04/06/2022.
//  Copyright © 2022 Daniel Earl. All rights reserved.
//

import UIKit
import StoreKit

class SupportUsViewController: UIViewController {

    @IBOutlet weak var ProductTitle: UILabel!
    @IBOutlet weak var ProductDetail: UILabel!
    @IBOutlet weak var ProductPrice: UILabel!
    @IBOutlet weak var ProductPurchaseBtn: UIButton!
    @IBOutlet weak var IAPLoadingView: UIView!
    
    let kTipCount = "countOfTipsGiven"
    let kHasTipped = "userHasSupported"
    let tipLimit = 3
    var products = [SKProduct]()
    
    // MARK: - Functions
    func getNumberOfTipsGiven() -> Int {
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: kTipCount)
    }
    
    func updateNumberOfTipsGiven() {
        let userDefaults: UserDefaults = UserDefaults.standard
        let count = userDefaults.integer(forKey: kTipCount)
        let update = count + 1
        userDefaults.set(update, forKey: kTipCount)
        userDefaults.set(true, forKey: kHasTipped)
        
        if update >= tipLimit {
            ProductPurchaseBtn.isEnabled = false
        }
    }
    
    func showIAPRelatedError(_ error: Error) {
        let alertMsg = error.localizedDescription
        let alert = UIAlertController(title: "In App Purchase Error", message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in NSLog("IAP ERROR: " + alertMsg)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - In App Purchase
    @IBAction func purchaseTip(_ sender: Any) {
        if !self.purchase(product: products[0]) {
            let alertMsg = "WARNING: In App Purchases not allowed on this device."
            let alert = UIAlertController(title: "Upgrade Purchase", message: alertMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in NSLog("IAP Not Allowed")}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func purchase(product: SKProduct) -> Bool {
        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            self.IAPLoadingView.isHidden = false
            IAPManager.shared.buy(product: product) { (result) in
                DispatchQueue.main.async {
                    self.IAPLoadingView.isHidden = true
                    switch result {
                        case .success(_):
                            self.updateNumberOfTipsGiven()
                        case .failure(let error):
                            self.showIAPRelatedError(error)
                    }
                }
            }
        }
        return true
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        if getNumberOfTipsGiven() <= tipLimit {
            IAPManager.shared.getProducts { (result) in
                DispatchQueue.main.async {
                    self.IAPLoadingView.isHidden = true
                    switch result {
                        case .success(let products): self.products = products
                        case .failure(let error):
                            self.showIAPRelatedError(error)
                            self.ProductTitle.text = "Digital Tip Currently Unavailable"
                            self.ProductTitle.isHidden = false
                    }
                    if self.products.count > 0 {
                        self.ProductDetail.text = self.products[0].localizedDescription
                        self.ProductTitle.text = self.products[0].localizedTitle
                        guard let price = IAPManager.shared.getPriceFormatted(for: self.products[0]) else {return}
                        self.ProductPrice.text = price
                        self.ProductTitle.isHidden = false
                        self.ProductPrice.isHidden = false
                        self.ProductDetail.isHidden = false
                        self.ProductPurchaseBtn.isHidden = false
                    }
                }
            }
        } else {
            self.ProductTitle.text = "Digital Tip Currently Unavailable"
            self.ProductTitle.isHidden = false
            self.IAPLoadingView.isHidden = true
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
