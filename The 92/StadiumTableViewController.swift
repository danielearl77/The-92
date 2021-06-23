//
//  StadiumTableViewController.swift
//  The 92
//
//  Created by Daniel Earl on 03/09/2020.
//  Copyright © 2020 Daniel Earl. All rights reserved.
//

import UIKit
import CoreData

class StadiumTableViewController: UITableViewController {

    // MARK: Vars
    let teamVisitCountImg = UIImage(named: "VisitCounter")
    var unwindFlag = false
    var league = ""
    
    var teams: [String] = []
    var visitCount: [String:Int] = [:]
    var oldGrounds: [NSManagedObject] = []
    var currentGrounds: [NSManagedObject] = []
    var groundNameList = ["Arsenal":"The Emirates","Aston Villa":"Villa Park","Brighton":"The Amex","Burnley":"Turf Moor","Chelsea":"Stamford Bridge","Crystal Palace":"Selhurst Park","Everton":"Goodison Park","Fulham":"Craven Cottage","Leeds Utd":"Elland Road","Leicester":"King Power Stadium","Liverpool":"Anfield","Man City":"Etihad Stadium","Man Utd":"Old Trafford","Newcastle":"St James Park","Sheffield Utd":"Bramall Lane","Southampton":"St Marys Stadium","Tottenham":"Tottenham Hotspur Stadium","West Brom":"The Hawthorns","West Ham":"The London Stadium","Wolves":"Molineux","Barnsley":"Oakwell","Birmingham":"St Andrews","Blackburn":"Ewood Park","Brentford":"Community Stadium","Bristol City":"Ashton Gate","Bournemouth":"Vitality Stadium","Cardiff":"Cardiff City Stadium","Coventry":"Ricoh Arena","Derby County":"Pride Park","Huddersfield":"John Smiths Stadium","Luton Town":"Kenilworth Road","Middlesbrough":"Riverside Stadium","Millwall":"The New Den","Nottingham Forest":"The City Ground","Norwich City":"Carrow Road","Preston":"Deepdale","QPR":"Kiyan Prince Foundation Stadium","Reading":"Madejski Stadium","Rotherham":"New York Stadium","Sheffield Wednesday":"Hillsborough","Stoke":"bet365 Stadium","Swansea":"Liberty Stadium","Watford":"Vicarage Road","Wycombe Wanderers":"Adams Park","Accrington Stanley":"Wham Stadium","AFC Wimbledon":"Plough Lane","Blackpool":"Bloomfield Road","Bristol Rovers":"Memorial Stadium","Burton Albion":"Pirelli Stadium","Charlton Athletic":"The Valley","Crewe Alexandra":"Alexandra Stadium","Doncaster Rovers":"Keepmoat Stadium","Fleetwood":"Highbury Stadium","Gillingham":"Priestfield","Hull City":"KCOM Stadium","Ipswich":"Portman Road","Lincoln City":"LNER Stadium","MK Dons":"Stadium MK","Northampton Town":"PTS Academy Stadium","Oxford Utd":"Kassam Stadium","Peterborough Utd":"Weston Homes Stadium","Plymouth":"Home Park","Portsmouth":"Fratton Park","Rochdale":"Crown Oil Arena","Shrewsbury Town":"Montgomery Waters Meadow","Sunderland":"Stadium of Light","Swindon Town":"Country Ground","Wigan":"DW Stadium","Barrow":"Progression Solicitors Stadium","Bradford City":"Utilita Energy Stadium","Bolton":"University of Bolton Stadium","Cambridge Utd":"Abbey Stadium","Carlisle Utd":"Brunton Park","Cheltenham Town":"Jonny-Rocks Stadium","Colchester Utd":"JobServe Stadium","Crawley Town":"Peoples Pension Stadium","Exeter City":"St James Park","Forest Green Rovers":"The New Lawn","Hartlepool Utd":"Victoria Park","Harrogate Town":"CNG Stadium","Leyton Orient":"Breyer Group Stadium","Mansfield Town":"One Call Stadium","Morecambe":"Globe Arena","Newport County":"Rodney Parade","Oldham Athletic":"Boundary Park","Port Vale":"Vale Park","Salford City":"Peninsula Stadium","Scunthorpe Utd":"Sands Venue Stadium","Sutton Utd":"Gander Green Lane","Stevenage":"Lamex Stadium","Tranmere Rovers":"Prenton Park","Walsall":"Banks Stadium"]
    
    // MARK: Team Lists
    var premierLeagueTeams = ["Arsenal","Aston Villa","Brentford","Brighton","Burnley","Chelsea","Crystal Palace","Everton","Leeds Utd","Leicester","Liverpool","Man City","Man Utd","Newcastle","Norwich City","Southampton","Tottenham","Watford","West Ham","Wolves"]
    var championshipTeams: [String] = ["Barnsley","Birmingham","Blackburn","Blackpool","Bristol City","Bournemouth","Cardiff","Coventry","Derby County","Fulham","Huddersfield","Hull City","Luton Town","Middlesbrough","Millwall","Nottingham Forest","Peterborough Utd","Preston","QPR","Reading","Sheffield Utd","Stoke","Swansea","West Brom"]
    var leagueOneTeams: [String] = ["Accrington Stanley","AFC Wimbledon","Bolton","Burton Albion","Cambridge Utd","Charlton Athletic","Cheltenham Town","Crewe Alexandra","Doncaster Rovers","Fleetwood","Gillingham","Ipswich","Lincoln City","MK Dons","Morecambe","Oxford Utd","Plymouth","Portsmouth","Rotherham","Sheffield Wednesday","Shrewsbury Town","Sunderland","Wigan","Wycombe Wanderers"]
    var leagueTwoTeams: [String] = ["Barrow","Bradford City","Bristol Rovers","Carlisle Utd","Colchester Utd","Crawley Town","Exeter City","Forest Green Rovers","Harrogate Town","Hartlepool Utd","Leyton Orient","Mansfield Town","Newport County","Northampton Town","Oldham Athletic","Port Vale","Rochdale","Salford City","Scunthorpe Utd","Stevenage","Sutton Utd","Swindon Town","Tranmere Rovers","Walsall"]
   
    // MARK: Outlets
    @IBOutlet weak var LeagueCount: UIBarButtonItem!
    
    // MARK: CoreData Functions
    func getLeagueVisitCount(team: String) -> Bool {
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
            let teams = try managedContext.fetch(fetchRequest)
            if teams.count > 0 {
                for t in teams {
                    let is92 = t.value(forKeyPath: "is_92") ?? false
                    if is92 as! Bool {
                        if t.value(forKeyPath: "visit_count") != nil {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            } else {
                return false
            }
            
            /*
            let singleTeam = try managedContext.fetch(fetchRequest)
            let is92 = singleTeam.first?.value(forKeyPath: "is_92") ?? false
            
            if is92 as! Bool {
                if singleTeam.first?.value(forKeyPath: "visit_count") != nil {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
            */
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        return false
    }
  
    
    func getTeamVisitCount(team: String) -> Int {
        var count = 0
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return count
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
            
        if appDelegate.coreDataError {
            coreDataAlerts(msg: appDelegate.coreDataErrorMsg)
            return count
        }
            
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroundRecord")
        fetchRequest.predicate = NSPredicate(format: "team_name == %@", team)
            
        do {
            currentGrounds = try managedContext.fetch(fetchRequest)
            let grounds = currentGrounds
            if grounds.count > 0 {
                for g in grounds {
                    let is92 = g.value(forKeyPath: "is_92") ?? false
                    if is92 as! Bool {
                        if g.value(forKeyPath: "visit_count") != nil {
                            count = g.value(forKeyPath: "visit_count") as! Int
                        } else {
                            count = 0
                        }
                    }
                }
            } else {
                count = 0
            }
            
            
            /*
            let is92 = ground.first?.value(forKeyPath: "is_92") ?? false
            
            if is92 as! Bool {
                if ground.first?.value(forKeyPath: "visit_count") != nil {
                    count = ground.first?.value(forKeyPath: "visit_count") as! Int
                } else {
                    count = 0
                }
            } else {
                count = 0
            }
            */
        } catch let error as NSError {
            NSLog("Could not fetch. \(error), \(error.userInfo)")
            return count
        }
        return count
    }
    
    // MARK: Functions
    func coreDataAlerts(msg: String) {
        let alert = UIAlertController(title: "ERROR", message: "There has been a database error. This App will now close.\nPlease re-open the app and try again. If this error persists please contact help@phone-app.co.uk", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in fatalError(msg)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func workOutLeagueCount(teams: [String]) -> Int {
        var leagueTotalCount = 0
        for t in teams {
            if getLeagueVisitCount(team: t) {
                leagueTotalCount += 1
            }
        }
        return leagueTotalCount
    }
   
    // MARK: - View
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
        if league == "prem" {
            LeagueCount.title = "\(workOutLeagueCount(teams: premierLeagueTeams)) of 20"
        }
        if league == "champ" {
            LeagueCount.title = "\(workOutLeagueCount(teams: championshipTeams)) of 24"
        }
        if league == "one" {
            LeagueCount.title = "\(workOutLeagueCount(teams: leagueOneTeams)) of 24"
        }
        if league == "two" {
            LeagueCount.title = "\(workOutLeagueCount(teams: leagueTwoTeams)) of 24"
        }
    }
    
    override func viewDidLoad() {
        if league == "prem" {
            teams = premierLeagueTeams
        }
        if league == "champ" {
            teams = championshipTeams
        }
        if league == "one" {
            teams = leagueOneTeams
        }
        if league == "two" {
            teams = leagueTwoTeams
        }
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !unwindFlag {
            self.performSegue(withIdentifier: "backToLeagueSelect", sender: self)
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if league == "old" {
            return oldGrounds.count
        } else {
            return teams.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "teamCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StadiumTableViewCell else {
            fatalError("The dequeued cell is not an instance of StadiumTableViewCell.")
        }
        if(league == "old") {
            let team = oldGrounds[indexPath.row]
            let teamName = team.value(forKey: "team_name") as? String
            let stadiumName = team.value(forKey: "ground_name") as? String
            cell.teamName.text = teamName
            cell.stadiumName.text = stadiumName
            cell.teamVisitCount.text = ""
            cell.teamVisitCountImg.image = UIImage(named: "NoVisitCounter")
            let teamIcon: UIImage=UIImage(named: teamName ?? "teamIconPlaceholder") ?? UIImage(named: "teamIconPlaceholder")!
            cell.teamLogo.image=teamIcon
        } else {
            let team = teams[indexPath.row]
            cell.teamName.text = teams[indexPath.row]
            cell.stadiumName.text = groundNameList[team]
            let visitCount = getTeamVisitCount(team: team)
            if visitCount > 0 {
                cell.teamVisitCount.text = String(visitCount)
                cell.teamVisitCountImg.image = teamVisitCountImg
            } else {
                cell.teamVisitCount.text = ""
                cell.teamVisitCountImg.image = UIImage(named: "NoVisitCounter")
            }
            let teamIcon: UIImage=UIImage(named: teams[indexPath.row]) ?? UIImage(named: "teamIconPlaceholder")!
            cell.teamLogo.image=teamIcon
        }
        return cell
    }
        
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if tableView.indexPathForSelectedRow != nil
        {
            if league == "old" {
                unwindFlag = true
                let indexPath = tableView.indexPathForSelectedRow!
                let selected = indexPath.row
                let stadiumDetailViewController = segue.destination as? StadiumDetailViewController
                let team = oldGrounds[selected]
                stadiumDetailViewController?.title = team.value(forKey: "ground_name") as? String
                stadiumDetailViewController?.groundName = team.value(forKey: "ground_name") as? String ?? ""
                stadiumDetailViewController?.selectedTeam = team.value(forKey: "team_name") as? String ?? ""
                stadiumDetailViewController?.isOld = true
            } else {
                unwindFlag = true
                let indexPath = tableView.indexPathForSelectedRow!
                let selected = indexPath.row
                let stadiumDetailViewController = segue.destination as? StadiumDetailViewController
                let team = teams[selected]
                stadiumDetailViewController?.title = groundNameList[team]
                stadiumDetailViewController?.groundName = groundNameList[team] ?? ""
                stadiumDetailViewController?.selectedTeam = team
            }
        }
    }
}
