//
//  ViewController.swift
//  The 92
//
//  Created by Daniel Earl on 01/09/2020.
//  Copyright © 2020 Daniel Earl. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit
import StoreKit

class ViewController: UIViewController {
    
    // MARK: NEW SEASON VERSION
    /*
     * THIS IS THE NEW SEASON VERSION CONSTANT AND MUST ONLY BE
     * CHANGED ON NEW SEASON UPDATE RELEASE. IT MUST MATCH THE
     * NEW LIVE VERSION NUMBER FOR THE NEW SEASON
     * Default value is -1 to not trigger new season updates
     */
        let newSeasonVersionNumber = "3.0"
    /*
     * Enter new values here AND update Team, Stadium, and Stadium Map Arrays as needed
     * comment out any not needed for this update
     */
        let promotedTeams = ["Stockport County","Grimsby Town"]
        let relegatedTeams = ["Scunthorpe Utd","Oldham Athletic"]
        //let changedGroundName = ["Team Name":"Team Name"]
        //let movedGrounds = ["Team Name":"Team Name"]
    /*
     * END OF NEW SEASON VERSION NUMBER
     */
    
    // MARK: Outlets
    @IBOutlet weak var TotalVisitCount: UILabel!
    @IBOutlet weak var TotalOldGroundsCount: UILabel!
    @IBOutlet weak var WhereIsHome: UILabel!
    @IBOutlet weak var SupportUsBtn: UIButton!
    
    // MARK: Vars
    var mainVisitText = " of 92"
    var oldVisitText = " other grounds"
    var homeTeam = ""
    var confettiRun = false
    var launch = -1
    var all92Visits: [NSManagedObject] = []
    var allOldVisits: [NSManagedObject] = []
    var homeStadium: [NSManagedObject] = []
    let emitterNode = SKEmitterNode(fileNamed: "confetti.sks")!
    
    // MARK: Constants
    let kAppVersion = "appVersionNumber"
    let kIsFirstLaunch = "appFirstLaunch"
    let kLaunchCount = "appLaunchNumber"
    let kHasReivewed = "appUserReviewPrompt"
    let kHalfConfetti = "half92Done"
    let kHasTipped = "userHasSupported"
    
    // MARK: Core Data Functions
    func getHomeStadium() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
            
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
            
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "is_home == %@", NSNumber(value: true))
            
        do {
            homeStadium = try managedContext.fetch(fetchRequest)
            let haveHomeSet = homeStadium.count
            if haveHomeSet > 0 {
                homeTeam = (homeStadium.first?.value(forKeyPath: "team_name") as? String)!
                return true
            }
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        return false
    }
    
    func getPrimaryVisitCount() -> Int {
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
        fetchRequest.predicate = NSPredicate(format: "is_92 == %@", NSNumber(value: true))
        
        do {
            all92Visits = try managedContext.fetch(fetchRequest)
            record = all92Visits.count
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            record = 0
        }
        return record
    }
    
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
            allOldVisits = try managedContext.fetch(fetchRequest)
            record = allOldVisits.count
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            record = 0
        }
        return record
    }
    
    // UPDATE NEW SEASON DB CODE
    func updateGroundName(team: String, ground: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
          
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "team_name == %@", team)
        
        do {
            let loadedTeam = try managedContext.fetch(fetchRequest)
            if loadedTeam.count > 0 {
                for i in loadedTeam {
                    i.setValue(ground, forKeyPath: "ground_name")
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    func updateRelegation(team: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
          
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "team_name == %@", team)
        
        do {
            let loadedTeam = try managedContext.fetch(fetchRequest)
            if loadedTeam.count > 0 {
                for i in loadedTeam {
                    let is92Check = i.value(forKeyPath: "is_92") as! Bool
                    if is92Check {
                        i.setValue(false, forKeyPath: "is_92")
                        try managedContext.save()
                    }
                }
            }
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    func updateNewGround(team: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
          
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "team_name == %@", team)
        
        do {
            let loadedTeam = try managedContext.fetch(fetchRequest)
            if loadedTeam.count > 0 {
                for i in loadedTeam {
                    let is92Check = i.value(forKeyPath: "is_92") as! Bool
                    if is92Check {
                        i.setValue(false, forKeyPath: "is_92")
                        i.setValue(true, forKeyPath: "is_old_ground")
                        try managedContext.save()
                    }
                }
            }
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    func updatePromotion(team: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
          
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "team_name == %@", team)
        
        do {
            let loadedTeam = try managedContext.fetch(fetchRequest)
            if loadedTeam.count > 0 {
                for i in loadedTeam {
                    let is92Check = i.value(forKeyPath: "is_92") as! Bool
                    let isOldGroundCheck = i.value(forKeyPath: "is_old_ground") as! Bool
                    if !is92Check && !isOldGroundCheck {
                        i.setValue(true, forKeyPath: "is_92")
                        try managedContext.save()
                    }
                }
            }
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    // MARK: Class Functions
    @IBAction func SupportUs(_ sender: Any) {
        //self.tabBarController?.selectedIndex = 3
    }
    
    func hasSupported() {
        let userDefaults: UserDefaults = UserDefaults.standard
        let hasUserSupported = userDefaults.bool(forKey: kHasTipped);
        if(hasUserSupported) {
            SupportUsBtn.isHidden = true
        }
        
    }
    
    func createLabel(labelTextNumber: Int) -> String {
        let textString = String(labelTextNumber)
        return textString
    }
    
    func coreDataAlerts(msg: String) {
        let alert = UIAlertController(title: "ERROR", message: "There has been a database error. This App will now close.\nPlease re-open the app and try again. If this error persists please contact help@phone-app.co.uk", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in fatalError(msg)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addConfetti() {
        let skView = SKView(frame: view.frame)
        skView.backgroundColor = .clear
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = .clear
        skView.presentScene(scene)
        skView.isUserInteractionEnabled = false
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.addChild(emitterNode)
        emitterNode.position.y = scene.frame.maxY
        emitterNode.particlePositionRange.dx = scene.frame.width
        view.addSubview(skView)
        confettiRun = true
        
        _ = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { timer in
            self.emitterNode.particleBirthRate = 0.0
            _ = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { timer in
                scene.removeAllChildren()
                skView.removeFromSuperview()
            }
        }
    }
    
    func firstLaunch() {
        let userDefaults: UserDefaults = UserDefaults.standard
        launch = userDefaults.integer(forKey: kIsFirstLaunch)
        if launch != 1 {
            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
            NSLog("First Launch of App")
            userDefaults.set(1, forKey: kIsFirstLaunch)
            userDefaults.set(version, forKey: kAppVersion)
            userDefaults.set(false, forKey: kHalfConfetti)
        }
    }
    
    func getSetVersion() {
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        let userDefaults: UserDefaults = UserDefaults.standard
        let savedVersion = userDefaults.string(forKey: kAppVersion)
        if savedVersion != version as? String {
            if version as? String == newSeasonVersionNumber {
                runNewSeasonUpdates()
                userDefaults.setValue(version, forKey: kAppVersion)
            } else {
                userDefaults.setValue(version, forKey: kAppVersion)
            }
        }
    }
    
    func userReview() -> Bool {
        let userDefaults: UserDefaults = UserDefaults.standard
        let userHadReviewed = userDefaults.bool(forKey: kHasReivewed)
        var launchCount = userDefaults.integer(forKey: kLaunchCount)
        
        if userHadReviewed {
            return false
        } else {
            if launchCount < 10 {
                launchCount += 1
                userDefaults.set(launchCount, forKey: kLaunchCount)
                return false
            } else {
                if all92Visits.count < 5 {
                    return false
                } else {
                    //SKStoreReviewController.requestReview()
                    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                    userDefaults.set(true, forKey: kHasReivewed)
                    return true
                }
            }
        }
    }
    
    func runNewSeasonUpdates() {
        // COMMENT OUT IF NOT NEEDED FOR THIS SEASON UPDATE
      
        for p in promotedTeams {
            _ = updatePromotion(team: p)
        }
        
        for r in relegatedTeams {
            _ = updateRelegation(team: r)
        }
        /*
        for n in changedGroundName {
            _ = updateGroundName(team: n.key, ground: n.value)
        }
    
        for m in movedGrounds {
            _ = updateNewGround(team: m.key)
        }
        */
     
    }
    
    // MARK: - View
    override func viewDidAppear(_ animated: Bool) {
        hasSupported()
        let visits = getPrimaryVisitCount()
        let oldVisits = getOldVisitCount()
        let userDefaults: UserDefaults = UserDefaults.standard
        let halfCount = userDefaults.bool(forKey: kHalfConfetti)
        TotalVisitCount.text = createLabel(labelTextNumber: visits) + mainVisitText
        
        if confettiRun == false {
            if visits >= 46 && halfCount == false {
                addConfetti()
                userDefaults.set(true, forKey: kHalfConfetti)
            }
            
            if visits == 92 {
                addConfetti()
            }
        }
        
        if oldVisits == 0 {
            TotalOldGroundsCount.isHidden = true
        } else {
            TotalOldGroundsCount.text = createLabel(labelTextNumber: oldVisits) + oldVisitText
        }
        let homeSet = getHomeStadium()
        if homeSet == true {
            if homeTeam != "" {
                WhereIsHome.text = "Home Team " + homeTeam
            } else {
                WhereIsHome.text = ""
            }
        } else {
            WhereIsHome.text = ""
        }
        if userReview() {
            NSLog("UserReview Dialog Shown")
        }
    }
    
    override func viewDidLoad() {
        firstLaunch()
        getSetVersion()
        hasSupported()
        
        let userDefaults: UserDefaults = UserDefaults.standard
        let halfCount = userDefaults.bool(forKey: kHalfConfetti)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if getPrimaryVisitCount() >= 46 && halfCount == false {
            addConfetti()
            userDefaults.set(true, forKey: kHalfConfetti)
        }       
        
        if getPrimaryVisitCount() == 92 {
            addConfetti()
        }
    }
}
