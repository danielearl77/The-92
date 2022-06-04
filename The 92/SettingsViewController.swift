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
        } else if ChangeView.selectedSegmentIndex == 3 {
            SettingsView.isHidden = false
            PrivacyView.isHidden = false
            SupportUsView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
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
        } else if ChangeView.selectedSegmentIndex == 3 {
            SettingsView.isHidden = false
            PrivacyView.isHidden = false
            SupportUsView.isHidden = true
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
