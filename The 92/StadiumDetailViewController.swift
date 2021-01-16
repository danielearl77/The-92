//
//  StadiumDetailViewController.swift
//  The 92
//
//  Created by Daniel Earl on 08/09/2020.
//  Copyright © 2020 Daniel Earl. All rights reserved.
//

import UIKit
import CoreData

class StadiumDetailViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: Vars
    var selectedTeam = ""
    var groundName = ""
    var is92 = false
    var isHome = false
    var isOld = false
    var lastVisit: Date = Date.init()
    var visitCount = 0
    var allVisits = ""
    var visitId = ""
    var noVisitYet = true
    var userHasAddedPhoto = false
    var savedTeam: [NSManagedObject] = []
    var savedHomeTeam: [NSManagedObject] = []
    
    // MARK: Outlets
    @IBOutlet weak var ListOfVisits: UITextView!
    @IBOutlet weak var ListOfVisitsLabel: UILabel!
    @IBOutlet weak var UserAddedPhoto: UIImageView!
    @IBOutlet weak var HomeGroundBtn: UIButton!
    @IBOutlet weak var SelectDateOfVisit: UIView!
    @IBOutlet weak var UserAddedPhotoView: UIView!
    @IBOutlet weak var AddVisitBtn: UIButton!
    @IBOutlet weak var UserSelectVisitDate: UIDatePicker!
    @IBOutlet weak var StadiumName: UILabel!
    @IBOutlet weak var DeleteVisitIcon: UIBarButtonItem!
    
    
    // MARK: Actions
    @IBAction func AddNewVisit(_ sender: Any) {
        SelectDateOfVisit.isHidden = false
        AddVisitBtn.isHidden = true
    }
    
    @IBAction func SaveNewVisit(_ sender: Any) {
        SelectDateOfVisit.isHidden = true
        AddVisitBtn.isHidden = false
        
        if noVisitYet {
            if saveFirstVisit() {
                populateVisit()
            } else {
                NSLog("Database Error")
            }
        } else if !noVisitYet {
            if updateVisit() {
                populateVisit()
            } else {
                NSLog("Database Error")
            }
        }
    }
    
    @IBAction func CancelSaveVisit(_ sender: Any) {
        SelectDateOfVisit.isHidden = true
        AddVisitBtn.isHidden = false
    }
    
    @IBAction func SetAsHomeGround(_ sender: Any) {
        if setHomeGround() == true {
            HomeGroundBtn.isHidden = true
        } else {
            NSLog("Home Ground Not Set")
        }
    }
    
    @IBAction func AddUserPhoto(_ sender: Any) {
        getPhotoFromUser()
    }
    
    @IBAction func DeleteVisits(_ sender: Any) {
        print("delete visit")
        let messageContent = "This will delete ALL visits to " + groundName + "\nAre You Sure?"
        let defaultAction = UIAlertAction(title: "OK", style: .default) {(action) in
            if self.deleteVisit(groundName: self.groundName) {
                self.performSegue(withIdentifier: "backToLeagueSelect", sender: self)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
            NSLog("Cancel Delete")
        }
        let alert = UIAlertController(title: "Delete Visits", message: messageContent, preferredStyle: .alert)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    
    // MARK: CoreData Functions
    func getVisit() -> Int {
        var record = 0
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return record
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return 0
        }
        /*
            either do a multi predicate on team and ground name
            or get records on team name and then in the do filter
            through the results comparing ground name and setting
            match to 'record'
         */
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        let teamPredicate = NSPredicate(format: "team_name == %@", selectedTeam)
        let groundPredicate = NSPredicate(format: "ground_name == %@", groundName)
        let teamGroundPredicate = NSCompoundPredicate(type: .and, subpredicates: [teamPredicate,groundPredicate])
        //fetchRequest.predicate = NSPredicate(format: "team_name == %@", selectedTeam)
        //fetchRequest.predicate = NSPredicate(format: "ground_name == %@", groundName)
        fetchRequest.predicate = teamGroundPredicate
        
        do {
            savedTeam = try managedContext.fetch(fetchRequest)
            record = savedTeam.count
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            record = 0
        }
        return record
    }
    
    func isHomeGroundSet() -> Bool {
        var isHomeSet = false
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
            savedHomeTeam = try managedContext.fetch(fetchRequest)
            if savedHomeTeam.count > 0 {
                isHomeSet = true
            }
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        return isHomeSet
    }
    
    func setHomeGround() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "id == %@", visitId)
        
        do {
            let loadedTeam = try managedContext.fetch(fetchRequest)
            // do a check here to make sure the record returned for given ID
            // is the same as the team view we are in!
            
            loadedTeam.first?.setValue(true, forKeyPath: "is_home")
            try managedContext.save()
            setHomeMessage(homeTeam: groundName)
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
        }
        return true
    }
    
    func updateVisit() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "id == %@", visitId)
 
        do {
            let loadedTeam = try managedContext.fetch(fetchRequest)
            if loadedTeam.count != 1 {
                NSLog("No Visit ID: We shouldn't really be in here!")
                return false
            } else {
                lastVisit = UserSelectVisitDate.date
                visitCount += 1
                let newAllVisits = allVisits + ":" + formatDate(selectedDate: lastVisit)
                loadedTeam.first?.setValue(lastVisit, forKeyPath: "last_visit")
                loadedTeam.first?.setValue(newAllVisits, forKeyPath: "all_visits")
                loadedTeam.first?.setValue(visitCount, forKeyPath: "visit_count")
                try managedContext.save()
            }
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    func saveFirstVisit() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "GroundRecord", in: managedContext)!
        let newGroundRecord = NSManagedObject(entity: entity, insertInto: managedContext)
        let groundRecordID = UUID().uuidString
        
        is92 = true
        visitCount = 1
        lastVisit = UserSelectVisitDate.date
        allVisits = formatDate(selectedDate: lastVisit)
        newGroundRecord.setValue(groundRecordID, forKeyPath: "id")
        newGroundRecord.setValue(selectedTeam, forKeyPath: "team_name")
        newGroundRecord.setValue(groundName, forKeyPath: "ground_name")
        newGroundRecord.setValue(is92, forKeyPath: "is_92")
        newGroundRecord.setValue(false, forKeyPath: "is_old_ground")
        newGroundRecord.setValue(isHome, forKeyPath: "is_home")
        newGroundRecord.setValue(visitCount, forKeyPath: "visit_count")
        newGroundRecord.setValue(lastVisit, forKeyPath: "last_visit")
        newGroundRecord.setValue(allVisits, forKeyPath: "all_visits")
        newGroundRecord.setValue(false, forKeyPath: "team_photo_set")
        
        do {
            try managedContext.save()
            savedTeam.append(newGroundRecord)
            noVisitYet = false
        } catch let error as NSError {
            NSLog("Could not save. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    func savePhoto() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "id == %@", visitId)
        
        do {
            let loadedTeam = try managedContext.fetch(fetchRequest)
            let imgData = UserAddedPhoto.image?.pngData()
            loadedTeam.first?.setValue(imgData, forKeyPath: "team_photo")
            loadedTeam.first?.setValue(true, forKeyPath: "team_photo_set")
            try managedContext.save()
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
        }
        return true
    }
    
    func deleteVisit(groundName: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
                
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return false
        }
                
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        //fetchRequest.predicate = NSPredicate(format: "ground_name == %@", groundName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", visitId)
                
                do {
                    let loadedTeam = try managedContext.fetch(fetchRequest)
                    managedContext.delete(loadedTeam.first!)
                    try managedContext.save()
                } catch let error as NSError {
                    NSLog("Could not fetch. \(error), \(error.userInfo)")
                    return false
            }
        return true
    }
    
    // MARK: Functions
    func populateVisit() {
        let showSavedTeam = savedTeam

        allVisits = (showSavedTeam.first?.value(forKeyPath: "all_visits") as? String)!
        visitId = (showSavedTeam.first?.value(forKeyPath: "id") as? String)!
        visitCount = showSavedTeam.first?.value(forKeyPath: "visit_count") as! Int
        
        let photo = showSavedTeam.first?.value(forKeyPath: "team_photo")
        let visitArray = allVisits.components(separatedBy: ":")
        var visitArrayByDate: [Date] = []
        var output = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        for i in visitArray {
            let date = dateFormatter.date(from: i)
            if let date = date {visitArrayByDate.append(date)}
        }
        let sortedVisitArray = visitArrayByDate.sorted(by: { $0.compare($1) == .orderedDescending })
        for i in sortedVisitArray {
            let date = formatDate(selectedDate: i)
            output += date + "\n"
        }
        ListOfVisits.text = output
        UserAddedPhotoView.isHidden = false
        ListOfVisits.isHidden = false
        ListOfVisitsLabel.isHidden = false
        if photo != nil {
            UserAddedPhoto.image = UIImage(data: photo as! Data)
            UserAddedPhotoView.layer.borderWidth = 1
            UserAddedPhotoView.layer.borderColor = UIColor.white.cgColor
        }
        
        isHome = isHomeGroundSet()
        if isHome == true {
            HomeGroundBtn.isHidden = true
        } else {
            HomeGroundBtn.isHidden = false
        }
        
        DeleteVisitIcon.isEnabled = true
    }
    
    func getPhotoFromUser() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func testFunc(test: String) {
        print(test)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        UserAddedPhoto.image = userPickedImage
        UserAddedPhotoView.layer.borderWidth = 1
        UserAddedPhotoView.layer.borderColor = UIColor.white.cgColor
        userHasAddedPhoto = true
        picker.dismiss(animated: true)
        let photoSaved = savePhoto()
        if photoSaved {
            NSLog("Photo Saved to DB")
        }
    }
    
    func formatDate(selectedDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let stringDate = formatter.string(from: selectedDate)
        return stringDate
    }
    
    func coreDataAlerts(msg: String) {
        let alert = UIAlertController(title: "ERROR", message: "There has been a database error. This App will now close.\nPlease re-open the app and try again. If this error persists please contact help@phone-app.co.uk", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in fatalError(msg)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setHomeMessage(homeTeam: String) {
        let messageText = homeTeam + " set as home ground."
        let alert = UIAlertController(title: "Home Team Set", message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in NSLog("HOME GROUND SET")}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK:  - View
    override func viewDidAppear(_ animated: Bool) {
        DeleteVisitIcon.isEnabled = false
        if isOld {
            AddVisitBtn.isHidden = true
        }
        let visit = getVisit()
        if visit > 0 {
            noVisitYet = false
            populateVisit()
        } else {
            noVisitYet = true
        }
    }
    
    override func viewDidLoad() {
        DeleteVisitIcon.isEnabled = false
        if isOld {
            AddVisitBtn.isHidden = true
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.performSegue(withIdentifier: "backToLeagueSelect", sender: self)
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
