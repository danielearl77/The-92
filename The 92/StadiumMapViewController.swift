//
//  StadiumMapViewController.swift
//  The 92
//
//  Created by Daniel Earl on 11/09/2020.
//  Copyright © 2020 Daniel Earl. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class StadiumMapViewController: UIViewController, MKMapViewDelegate {

    // MARK: Vars
    var allAnnotations: [MKAnnotation] = []
    var allTeams: [NSManagedObject] = []
    var teamList: [String] = []
    var mapTeams = [String:Int]()
    var mapCentrePoint = [52.514982, -1.362011]
    let homeMarkerColor = UIColor.init(red: 184/255, green: 151/255, blue: 76/255, alpha: 1.0)
    var homeTeam = ""
    var mapAnnotationRecord: [MKAnnotation] = []
    
    // MARK: Outlets
    @IBOutlet weak var StadiumMap: MKMapView!
    
    // MARK: Functions
    func showGroundsOnMap() {
        let res = getListOfTeams()
        if res == true {
            mapAnnotationRecord.removeAll()
            for (team, count) in mapTeams {
                let loc = Teams.shared.loadTeamDetails(team: team)
                let vCount = String(count)
                let visit = "Visits: " + vCount
                let stadium = StadiumMapAnnotation(title: team, visitCount: visit, coordinate: CLLocationCoordinate2D(latitude: loc.stadiumLat, longitude: loc.stadiumLon))
                mapAnnotationRecord.append(stadium)
                StadiumMap.addAnnotation(stadium)
            }
        }
        
        if !allAnnotations.isEmpty {
            allAnnotations.removeAll()
        }
        let mapAnnotations = StadiumMap.annotations(in: StadiumMap.visibleMapRect)
        for i in mapAnnotations {
            allAnnotations.append(i as! MKAnnotation)
        }
        
    }
    
    func hideGroundsOnMap() {
        StadiumMap.removeAnnotations(allAnnotations)
        homeTeam = ""
    }
    
    private func registerMapAnnotationViews() {
        StadiumMap.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(StadiumMapAnnotation.self))
    }
   
    func mapView(_ StadiumMap: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StadiumMapAnnotation else {
            return nil
        }
        
        let identifier = annotation.title!
        var view: MKMarkerAnnotationView
         
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier)
            view.displayPriority = .required
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x:-5, y:5)
            let image = UIImage(named: annotation.title!)
            view.glyphImage = UIImage(named: "MapIcons")
            if annotation.title == homeTeam {
                view.markerTintColor = homeMarkerColor
            } else {
                view.markerTintColor = .white
            }
            view.rightCalloutAccessoryView = UIImageView(image: image)
     
        return view
    }
    
    func centerMap() {
        let centerRegion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: mapCentrePoint[0], longitude: mapCentrePoint[1])
        let spanRegion: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 6.0, longitudeDelta: 6.0)
        let mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: centerRegion, span: spanRegion)
        StadiumMap.setRegion(mapRegion, animated: true)
    }
    
    func coreDataAlerts(msg: String) {
        let alert = UIAlertController(title: "ERROR", message: "There has been a database error. This App will now close.\nPlease re-open the app and try again. If this error persists please contact help@phone-app.co.uk", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in fatalError(msg)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: CoreData Functions
    func getListOfTeams() -> Bool {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return false
                }
            
                let managedContext = appDelegate.persistentContainer.viewContext
                
                if appDelegate.coreDataError {
                    coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
                    return false
                }
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
                fetchRequest.predicate = NSPredicate(format: "is_92 == %@", NSNumber(value: true))
                
                do {
                    allTeams = try managedContext.fetch(fetchRequest)
                    var counter = 0
                    while counter < allTeams.count {
                        let team = allTeams[counter]
                        let teamName = team.value(forKeyPath: "team_name")
                        let visitCount = team.value(forKeyPath: "visit_count")
                        mapTeams[teamName as! String] = visitCount as? Int
                        teamList.append(teamName as! String)
                        let home = (team.value(forKeyPath: "is_home") as? Bool)!
                        if home {
                            homeTeam = teamName as! String
                        }
                        counter += 1
                    }
                } catch let error as NSError {
                    NSLog("Could not fetch. \(error), \(error.userInfo)")
                    return false
                }
                return true
    }
    
    
    // MARK: -ViewDidAppear - ViewDidLoad
    override func viewDidAppear(_ animated: Bool) {
        if !mapTeams.isEmpty {
            mapTeams.removeAll()    
        }
        StadiumMap.delegate = self
        registerMapAnnotationViews()
        centerMap()
        showGroundsOnMap()
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideGroundsOnMap()
    }
    
}
