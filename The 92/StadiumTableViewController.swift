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
       
    // MARK: Team Lists
    var premierLeagueTeams = ["Arsenal","Aston Villa","Bournemouth","Brentford","Brighton & Hove Albion","Burnley","Chelsea","Crystal Palace","Everton","Fulham","Leeds United","Liverpool","Manchester City","Manchester United","Newcastle United","Nottingham Forest","Tottenham Hotspur","West Ham United","Wolverhampton Wanderers"]
    
    var championshipTeams: [String] = ["Birmingham City","Blackburn Rovers","Bristol City","Coventry City","Derby County","Hull City","Ipswich Town","Leicester City","Middlesbrough","Millwall","Norwich City","Oxford United","Portsmouth","Preston North End","Queens Park Rangers","Sheffield United","Sheffield Wednesday","Southampton","Stoke City","Sunderland","Swansea City","Watford","West Bromwich Albion","Wrexham"]
    
    var leagueOneTeams: [String] = ["Barnsley","Blackpool","Bolton Wanderers","Bradford City","Burton Albion","Cardiff City","Charlton Athletic","Doncaster Rovers","Exeter City","Huddersfield Town","Leyton Orient","Lincoln City","Luton Town","Mansfield Town","Northampton Town","Peterborough United","Plymouth Argyle","Port Vale","Reading","Rotherham United","Stevenage","Stockport County","Wigan Athletic","Wycombe Wanderers"]
    
    var leagueTwoTeams: [String] = ["AFC Wimbledon","Accrington Stanley","Barnet","Barrow","Bristol Rovers","Bromley","Cambridge United","Cheltenham Town","Chesterfield","Colchester United","Crawley Town","Crewe Alexandra","Fleetwood Town","Gillingham","Grimsby Town","Harrogate Town","MK Dons","Newport County","Notts County","Salford City","Shrewsbury Town","Swindon Town","Tranmere Rovers","Walsall"]
   
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
            cell.stadiumName.text = Teams.shared.loadTeamDetails(team: team).stadiumName
            
            
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
                stadiumDetailViewController?.title = Teams.shared.loadTeamDetails(team: team).stadiumName
                stadiumDetailViewController?.groundName = Teams.shared.loadTeamDetails(team: team).stadiumName
                stadiumDetailViewController?.selectedTeam = team
            }
        }
    }
}
