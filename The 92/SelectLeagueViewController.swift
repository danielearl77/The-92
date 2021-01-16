//
//  SelectLeagueViewController.swift
//  The 92
//
//  Created by Daniel Earl on 03/09/2020.
//  Copyright © 2020 Daniel Earl. All rights reserved.
//

import UIKit
import CoreData

class SelectLeagueViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var OldGroundsBtn: UIButton!
    
    // MARK: Vars
    var oldVisits: [NSManagedObject] = []
    
    // MARK: CoreData Function
    func getOldVisitCount() -> Int {
        var record = 0
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return record
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return 0
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "is_92 == %@", NSNumber(value: false))
        
        do {
            oldVisits = try managedContext.fetch(fetchRequest)
            record = oldVisits.count
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            record = 0
        }
        return record
    }
    
    // MARK: Functions
    func coreDataAlerts(msg: String) {
        let alert = UIAlertController(title: "ERROR", message: "There has been a database error. This App will now close.\nPlease re-open the app and try again. If this error persists please contact help@phone-app.co.uk", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in fatalError(msg)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - View
    override func viewDidLoad() {
        if(getOldVisitCount() > 0) {
            OldGroundsBtn.isHidden = false
        } else {
            OldGroundsBtn.isHidden = true
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(getOldVisitCount() > 0) {
            OldGroundsBtn.isHidden = false
        } else {
            OldGroundsBtn.isHidden = true
        }
    }
    
    // MARK: - Navigation
    @IBAction func unwindToSelectLeague(sender: UIStoryboardSegue) {}
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PremierLeague" {
            let staduimViewController = segue.destination as? StadiumTableViewController
            staduimViewController?.title = "Premier League Teams"
            staduimViewController?.league = "prem"
        }
        if segue.identifier == "Championship" {
            let staduimViewController = segue.destination as? StadiumTableViewController
            staduimViewController?.title = "Championship Teams"
            staduimViewController?.league = "champ"
        }
        
        if segue.identifier == "LeagueOne" {
            let staduimViewController = segue.destination as? StadiumTableViewController
            staduimViewController?.title = "League One Teams"
            staduimViewController?.league = "one"
        }
        
        if segue.identifier == "LeagueTwo" {
            let staduimViewController = segue.destination as? StadiumTableViewController
            staduimViewController?.title = "League Two Teams"
            staduimViewController?.league = "two"
        }
        
        if segue.identifier == "OldGrounds" {
            let staduimViewController = segue.destination as? StadiumTableViewController
            staduimViewController?.title = "Old Grounds"
            staduimViewController?.league = "old"
            staduimViewController?.oldGrounds = oldVisits
        }
    }
}
