//
//  SettingsViewController.swift
//  The 92
//
//  Created by Daniel Earl on 09/09/2020.
//  Copyright © 2020 Daniel Earl. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var SettingsView: UIView!
    @IBOutlet weak var PrivacyView: UIView!
    @IBOutlet weak var SupportUsView: UIView!
    @IBOutlet weak var ChangeView: UISegmentedControl!
    
    var fromSupportUsBtn = 0;
    let kHasTipped = "userHasSupported"
    let kTipCount = "countOfTipsGiven"
    
    @IBAction func switchOutView(_ sender: Any) {
        if ChangeView.selectedSegmentIndex == 0 {
            SettingsView.isHidden = false
            PrivacyView.isHidden = true
            SupportUsView.isHidden = true
        } else if ChangeView.selectedSegmentIndex == 1 {
            SettingsView.isHidden = true
            PrivacyView.isHidden = false
            SupportUsView.isHidden = true
        } else if ChangeView.selectedSegmentIndex == 2 {
            SettingsView.isHidden = true
            PrivacyView.isHidden = true
            SupportUsView.isHidden = false
        }
    }
    
    func hasSupported() -> Bool {
        let userDefaults: UserDefaults = UserDefaults.standard
        let hasUserSupported = userDefaults.bool(forKey: kHasTipped);
        print(hasUserSupported)
        return hasUserSupported
    }
    
    func getNumberOfTipsGiven() -> Int {
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: kTipCount)
    }
    
    override func viewDidLoad() {
        let tips = getNumberOfTipsGiven()
        
        if(!hasSupported()) {
            print("in hasn't supported")
            ChangeView.selectedSegmentIndex = 2
            ChangeView.sendActions(for: .valueChanged)
        }
        
        if(tips >= 3) {
            ChangeView.setEnabled(false, forSegmentAt: 2)
        }
        
        if ChangeView.selectedSegmentIndex == 0 {
            SettingsView.isHidden = false
            PrivacyView.isHidden = true
            SupportUsView.isHidden = true
        } else if ChangeView.selectedSegmentIndex == 1 {
            SettingsView.isHidden = true
            PrivacyView.isHidden = false
            SupportUsView.isHidden = true
        } else if ChangeView.selectedSegmentIndex == 2 {
            SettingsView.isHidden = true
            PrivacyView.isHidden = true
            SupportUsView.isHidden = false
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tips = getNumberOfTipsGiven()
        
        if(!hasSupported()) {
            print("in hasn't supported")
            ChangeView.selectedSegmentIndex = 2
            ChangeView.sendActions(for: .valueChanged)
        }
        
        if(tips >= 3) {
            ChangeView.setEnabled(false, forSegmentAt: 2)
        }
        
        if ChangeView.selectedSegmentIndex == 0 {
            SettingsView.isHidden = false
            PrivacyView.isHidden = true
            SupportUsView.isHidden = true
        } else if ChangeView.selectedSegmentIndex == 1 {
            SettingsView.isHidden = true
            PrivacyView.isHidden = false
            SupportUsView.isHidden = true
        } else if ChangeView.selectedSegmentIndex == 2 {
            SettingsView.isHidden = true
            PrivacyView.isHidden = true
            SupportUsView.isHidden = false
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
