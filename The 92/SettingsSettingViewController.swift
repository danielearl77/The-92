//
//  SettingsSettingViewController.swift
//  The 92
//
//  Created by Daniel Earl on 15/10/2020.
//  Copyright © 2020 Daniel Earl. All rights reserved.
//

import UIKit
import CoreData

class SettingsSettingViewController: UIViewController {

    // MARK: Vars
    var photoIds : [String] = []
    var teamPhotoSet : [NSManagedObject] = []
    let enabledImg = UIImage(named: "Buttons")
    let disabledImg = UIImage(named: "DisabledButton")
    let kHalfConfetti = "half92Done"
    
    // MARK: Outlets
    @IBOutlet weak var resetHomeBtn: UIButton!
    @IBOutlet weak var resetCountBtn: UIButton!
    @IBOutlet weak var removePhotosBtn: UIButton!
    
    // MARK: Actions
    @IBAction func resetHome(_ sender: Any) {
        
        let defaultAction = UIAlertAction(title: "OK", style: .default) {(action) in
            var reset = false
            let id = self.getHomeGround()
            if id != "false" {reset = self.unsetHomeGround(id: id)}
            if reset == true {
                NSLog("Home Ground Reset")
            } else {
                NSLog("ERROR: Could not reset home ground")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
            NSLog("Cancel Delete")
        }
        let alert = UIAlertController(title: "Reset Home Stadium", message: "Are You Sure?", preferredStyle: .alert)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func resetCount(_ sender: Any) {
        let defaultAction = UIAlertAction(title: "OK", style: .default) {(action) in
            let reset = self.deleteAllRecords()
            if reset == true {
                let userDefaults: UserDefaults = UserDefaults.standard
                userDefaults.set(false, forKey: self.kHalfConfetti)
                let photoBtnState = self.removePhotosBtn.isEnabled
                if photoBtnState {
                    self.removePhotosBtn.isEnabled = false
                    self.removePhotosBtn.setTitleColor(.white, for: .normal)
                    self.removePhotosBtn.setBackgroundImage(self.disabledImg, for: .normal)
                }
                NSLog("All Data Deleted")
                
            } else {
                NSLog("ERROR: Could not delete")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
            NSLog("Cancel Delete")
        }
        let alert = UIAlertController(title: "Reset Stadium Count", message: "WARNING: This deletes all visit data.\nAre You Sure?", preferredStyle: .alert)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func removePhotos(_ sender: Any) {
        let defaultAction = UIAlertAction(title: "OK", style: .default) {(action) in
            let photos = self.getPhotoRecords()
            if photos {
                let delPhoto = self.deleteAllPhotos()
                if delPhoto {
                    self.photoIds = []
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
            NSLog("Cancel Delete")
        }
        let alert = UIAlertController(title: "Remove Photos", message: "WARNING: This will remove ALL photos.\nThis only removes photos from this app, not your device.\nAre You Sure?", preferredStyle: .alert)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    
    // MARK: CoreData
    func getHomeGround() -> String {
        var id = ""
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return "false"
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
            
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return "false"
        }
            
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "is_home == %@", NSNumber(value: true))
            
        do {
            let savedHomeTeam = try managedContext.fetch(fetchRequest)
            if savedHomeTeam.count > 0 {
                id = (savedHomeTeam.first?.value(forKeyPath: "id") as? String)!
            }
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return "false"
        }
        return id
    }
    
    func unsetHomeGround(id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let loadedTeam = try managedContext.fetch(fetchRequest)
            if loadedTeam.count > 0 {
                loadedTeam.first?.setValue(false, forKeyPath: "is_home")
                try managedContext.save()
                resetHomeBtn.isEnabled = false
                resetHomeBtn.setTitleColor(.white, for: .normal)
                resetHomeBtn.setBackgroundImage(disabledImg, for: .normal)
            } else {
                return false
            }
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
        }
        return true
    }
    
  
    func deleteAllRecords() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GroundRecord")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(batchDeleteRequest)
            resetCountBtn.isEnabled = false
            resetCountBtn.setTitleColor(.white, for: .normal)
            resetCountBtn.setBackgroundImage(disabledImg, for: .normal)
            resetHomeBtn.isEnabled = false
            resetHomeBtn.setTitleColor(.white, for: .normal)
            resetHomeBtn.setBackgroundImage(disabledImg, for: .normal)
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    func getPhotoRecords() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
            
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
            
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "team_photo_set == %@", NSNumber(value: true))
            
        do {
            teamPhotoSet = try managedContext.fetch(fetchRequest)
            if teamPhotoSet.count != 0 {
                var c = 0
                while c < teamPhotoSet.count {
                    photoIds.append(teamPhotoSet[c].value(forKeyPath: "id") as! String)
                    c += 1
                }
            } else {
                return false
            }
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    func deleteAllPhotos() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
        
        for id in photoIds {
         
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let loadedTeam = try managedContext.fetch(fetchRequest)
                if loadedTeam.count > 0 {
                    loadedTeam.first?.setValue(nil, forKeyPath: "team_photo")
                    loadedTeam.first?.setValue(false, forKeyPath: "team_photo_set")
                    try managedContext.save()
                    removePhotosBtn.isEnabled = false
                    removePhotosBtn.setTitleColor(.white, for: .normal)
                    removePhotosBtn.setBackgroundImage(disabledImg, for: .normal)
                } else {
                    return false
                }
            } catch let error as NSError {
                NSLog("Could not fetch. \(error), \(error.userInfo)")
                return false
            }
        }
        return true
    }
    
    // MARK: Functions
    func coreDataAlerts(msg: String) {
        let alert = UIAlertController(title: "ERROR", message: "There has been a database error. This App will now close.\nPlease re-open the app and try again. If this error persists please contact help@phone-app.co.uk", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in fatalError(msg)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Views
    override func viewDidAppear(_ animated: Bool) {
        let homeSet = getHomeGround()
        let havePhotos = getPhotoRecords()
        let visitCount = ViewController().getPrimaryVisitCount()
       
        if visitCount > 0 {
            resetCountBtn.isEnabled = true
            resetCountBtn.setTitleColor(.black, for: .normal)
            resetCountBtn.setBackgroundImage(enabledImg, for: .normal)
        } else {
            resetCountBtn.isEnabled = false
            resetCountBtn.setTitleColor(.white, for: .normal)
            resetCountBtn.setBackgroundImage(disabledImg, for: .normal)
        }
        
        if homeSet == "" {
            resetHomeBtn.isEnabled = false
            resetHomeBtn.setTitleColor(.white, for: .normal)
            resetHomeBtn.setBackgroundImage(disabledImg, for: .normal)
        } else {
            resetHomeBtn.isEnabled = true
            resetHomeBtn.setTitleColor(.black, for: .normal)
            resetHomeBtn.setBackgroundImage(enabledImg, for: .normal)
        }
        if havePhotos {
            removePhotosBtn.isEnabled = true
            removePhotosBtn.setTitleColor(.black, for: .normal)
            removePhotosBtn.setBackgroundImage(enabledImg, for: .normal)
        } else {
            removePhotosBtn.isEnabled = false
            removePhotosBtn.setTitleColor(.white, for: .normal)
            removePhotosBtn.setBackgroundImage(disabledImg, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
