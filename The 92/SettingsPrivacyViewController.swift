//
//  SettingsPrivacyViewController.swift
//  The 92
//
//  Created by Daniel Earl on 12/12/2020.
//  Copyright © 2020 Daniel Earl. All rights reserved.
//

import UIKit

class SettingsPrivacyViewController: UIViewController {

    @IBOutlet weak var privacyCreditText: UITextView!
    
    func loadTextIntoView() {
        let versionNumber = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let copyrightYear = dateFormatter.string(from: date)
        
        let headerFont = UIFont.boldSystemFont(ofSize: 18.0)
        let bodyFont = UIFont.systemFont(ofSize: 15.0)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        let headerAttributes = [NSAttributedString.Key.font: headerFont]
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: UIColor.systemGray,
            .paragraphStyle: paragraphStyle]
        
        let privacyBodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: UIColor.systemGray,
            .paragraphStyle: paragraphStyle]
        
        let creditBodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: UIColor.systemGray,
            .paragraphStyle: paragraphStyle]
        
        let aboutHeader = "About\n"
        let aboutBody = "If you are trying to do the '92' then this app is for you. It provides a handy record of all the grounds you have visited in your quest to complete The 92.\n\nThis app will be updated to take into account promotion and relegation at the end of each season. You may well drop 2 grounds at the end of each season!\n\nThis app is not affiliated with the FA, The EPL, The EFL, or its clubs.  No club has provided any information for this app.\n\n"
        let privacyHeader = "Privacy\n"
        let privacyBody = "This app (The 92) stores a record of football grounds a user has visited. No personal identifying information is stored, harvested, or transmitted back to us (phone-app.co.uk). This app stores photos that the user chooses to add to a stadium visit record, that may be stored elsewhere on the device. We (phone-app.co.uk) do not have access to the visit records or photos stored in this app. The user may remove all stored data in this app by accessing the settings page and touching on Reset Stadium Count, or Remove Photos.\n\n"
        let creditHeader = "Credits\n"
        let creditBody = "THE 92\nCopyright (c) 2020 - \(copyrightYear) D. Earl\nBackground Image and Icon Image courtesy of iStockPhoto, all other images and icons copyright (c) D. Earl. For more information or to get in touch please visit our website.\n\nVersion Number: \(versionNumber)"
        
        let privacyText = NSMutableAttributedString(string: aboutHeader, attributes: headerAttributes)
        let aboutBodyText = NSAttributedString(string: aboutBody, attributes: bodyAttributes)
        let privacyHeaderText = NSAttributedString(string: privacyHeader, attributes: headerAttributes)
        let privacyBodyText = NSAttributedString(string: privacyBody, attributes: privacyBodyAttributes)
        let creditHeaderText = NSAttributedString(string: creditHeader, attributes: headerAttributes)
        let creditBodyText = NSAttributedString(string: creditBody, attributes: creditBodyAttributes)
        
        privacyText.append(aboutBodyText)
        privacyText.append(privacyHeaderText)
        privacyText.append(privacyBodyText)
        privacyText.append(creditHeaderText)
        privacyText.append(creditBodyText)
        
        privacyCreditText.attributedText = privacyText
    }
    
    override func viewDidLoad() {
        loadTextIntoView()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
