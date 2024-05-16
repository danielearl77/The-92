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
    /*
    var teams = ["Arsenal":[51.5550526,-0.105846],"Aston Villa":[52.5088714,-1.8848723],"Brighton":[50.86185,-0.08248],"Burnley":[53.7884704,-2.2303248],"Chelsea":[51.4820072,-0.1907663],"Crystal Palace":[51.3978941,-0.0859235],"Everton":[53.4391966,-2.9670169],"Fulham":[51.4740754,-0.2215902],"Leeds Utd":[53.7771779,-1.5715315],"Leicester":[52.6200439,-1.1414997],"Liverpool":[53.4316023,-2.9605416],"Man City":[53.4838763,-2.1992886],"Man Utd":[53.4632114,-2.2911967],"Newcastle":[54.9752008,-1.622355],"Sheffield Utd":[53.3698603,-1.4705122],"Southampton":[50.9065298,-1.3908231],"Tottenham":[51.6031464,-0.0676001],"West Brom":[52.5096036,-1.9638304],"West Ham":[51.53867,-0.01649],"Wolves":[52.5908129,-2.130635],"Barnsley":[53.5522662,-1.4686315],"Birmingham":[52.474486,-1.866873],"Blackburn":[53.7294672,-2.4881448],"Brentford":[51.490821,-0.288618],"Bristol City":[51.439884,-2.6210076],"Bournemouth":[50.734901,-1.8389888],"Cardiff":[51.472830,-3.203030],"Coventry":[52.4482668,-1.497429],"Derby County":[52.9146511,-1.448016],"Huddersfield":[53.6540252,-1.7731935],"Luton Town":[51.8841800,-0.4316600],"Middlesbrough":[54.5781243,-1.2177641],"Millwall":[51.4866709,-0.0510526],"Nottingham Forest":[52.9394531,-1.1331991],"Norwich City":[52.6223803,1.308603],"Preston":[53.7722293,-2.6893447],"QPR":[51.510610,-0.230760],"Reading":[51.4223249,-0.9834968],"Rotherham":[53.4296308,-1.3611662],"Sheffield Wednesday":[53.4116501,-1.5021879],"Stoke":[52.9891356,-2.1737192],"Swansea":[51.6421561,-3.9351185],"Watford":[51.6499300,-0.4015600],"Wycombe Wanderers":[51.6311336,-0.7972369],"Accrington Stanley":[53.7645074,-2.3704834],"AFC Wimbledon":[51.431547,-0.186599],"Blackpool":[53.8041828,-3.0467969],"Bristol Rovers":[51.4858436,-2.5835966],"Burton Albion":[52.821462,-1.6270024],"Charlton Athletic":[51.486687,0.0358469],"Crewe Alexandra":[53.0879308,-2.4361022],"Doncaster Rovers":[53.5097718,-1.1129534],"Fleetwood":[53.91651,-3.02478],"Gillingham":[51.3848726,0.5597597],"Hull City":[53.7457315,-0.3680162],"Ipswich":[52.0542255,1.1447102],"Lincoln City":[53.2181763,-0.540056],"MK Dons":[52.0093942,-0.7328938],"Northampton Town":[52.235099,-0.9342712],"Oxford Utd":[51.7175536,-1.2112956],"Peterborough Utd":[52.5652665,-0.2403379],"Plymouth":[50.3873937,-4.1517004],"Portsmouth":[50.7959228,-1.0648815],"Shrewsbury Town":[52.6884899,-2.7484126],"Sunderland":[54.9147354,-1.3874242],"Swindon Town":[51.5647848,-1.7699336],"Wigan":[53.5471948,-2.6545159],"Barrow":[54.12330,-3.23494],"Bradford fCity":[53.8035782,-1.7594818],"Bolton":[53.5807096,-2.5366891],"Cambridge Utd":[52.2121000,0.1541300],"Carlisle Utd":[54.8958163,-2.9144752],"Cheltenham Town":[51.9055762,-2.0620928],"Colchester Utd":[51.923364,0.896093],"Crawley Town":[51.099568,-0.1953945],"Exeter City":[50.7297825,-3.5209573],"Harrogate Town":[53.99173,-1.51448],"Leyton Orient":[51.5602116,-0.0118855],"Mansfield Town":[53.1380700,-1.2007600],"Morecambe":[54.061180,-2.866935],"Newport County":[51.5882700,-2.9879900],"Port Vale":[53.0503903,-2.1916971],"Salford City":[53.51363,-2.27674],"Stevenage":[51.8897477,-0.1920352],"Tranmere Rovers":[53.3732067,-3.035836],"Walsall":[52.5655187,-1.991164],"Stockport County":[53.39992,-2.16712],"Grimsby Town":[53.570247,-0.046709],"Notts County":[52.94224,-1.13610],"Wrexham":[53.05195,-3.00362]]
    */
      /*
        "Oldham Athletic":[53.5543382,-2.1280832]
        "Scunthorpe Utd":[53.5872359,-0.6948787]
        "Hartlepool Utd":[54.68957,-1.21360]
        "Rochdale":[53.6191217,-2.1800118]
        "Forest Green Rovers":[51.699104,-2.237933]
        "Sutton Utd":[51.36759,-0.20429]
     */
    
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
                print(team)
                //let loc = teams[team]
                let loc = Teams.shared.loadTeamDetails(team: team)
                let vCount = String(count)
                let visit = "Visits: " + vCount
                let stadium = StadiumMapAnnotation(title: team, visitCount: visit, coordinate: CLLocationCoordinate2D(latitude: loc.stadiumLat, longitude: loc.stadiumLon))
                //let stadium = StadiumMapAnnotation(title: team, visitCount: visit, coordinate: CLLocationCoordinate2D(latitude: loc![0], longitude: loc![1]))
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
