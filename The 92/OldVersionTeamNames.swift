//
//  OldVersionTeamNames.swift
//  The 92
//
//  Created by Daniel Earl on 10/05/2024.
//  Copyright © 2024 Daniel Earl. All rights reserved.
//

import Foundation

class OldVersionTeamNames: NSObject {
    static let shared = OldVersionTeamNames()
    
    let teamsNeedingUpdate = ["Birmingham","Blackburn","Bolton","Brighton","Cambridge Utd","Cardiff","Carlisle Utd","Colchester Utd","Coventry","Fleetwood","Huddersfield","Ipswich","Leeds Utd","Leicester","Man City","Man Utd","Newcastle","Oxford Utd","Peterborough Utd","Plymouth","Preston","QPR","Rotherham","Sheffield Utd","Stoke","Swansea","Tottenham","West Brom","West Ham","Wigan","Wolves"]
    
    func checkTeamName(team: String) -> String {
        if team == "Brighton" {
            return "Brighton & Hove Albion"
        } else if team == "Ipswich" {
            return "Ipswich Town"
        } else if team == "Leicester" {
            return "Leicester City"
        } else if team == "Man City" {
            return "Manchester City"
        } else if team == "Man Utd" {
            return "Manchester United"
        } else if team == "Newcastle" {
            return "Newcastle United"
        } else if team == "Tottenham" {
            return "Tottenham Hotspur"
        } else if team == "West Ham" {
            return "West Ham United"
        } else if team == "Wolves" {
            return "Wolverhampton Wanderers"
        } else if team == "Blackburn" {
            return "Blackburn Rovers"
        } else if team == "Cardiff" {
            return "Cardiff City"
        } else if team == "Coventry" {
            return "Coventry City"
        } else if team == "Leeds Utd" {
            return "Leeds United"
        } else if team == "Plymouth" {
            return "Plymouth Argyle"
        } else if team == "Preston" {
            return "Preston North End"
        } else if team == "QPR" {
            return "Queens Park Rangers"
        } else if team == "Sheffield Utd" {
            return "Sheffield United"
        } else if team == "Stoke" {
            return "Stoke City"
        } else if team == "Swansea" {
            return "Swansea City"
        } else if team == "West Brom" {
            return "West Bromwich Albion"
        } else if team == "Birmingham" {
            return "Birmingham City"
        } else if team == "Bolton" {
            return "Bolton Wanderers"
        } else if team == "Cambridge Utd" {
            return "Cambridge United"
        } else if team == "Carlisle Utd" {
            return "Carlisle United"
        } else if team == "Fleetwood" {
            return "Fleetwood Town"
        } else if team == "Huddersfield" {
            return "Huddersfield Town"
        } else if team == "Oxford Utd" {
            return "Oxford United"
        } else if team == "Peterborough Utd" {
            return "Peterborough United"
        } else if team == "Rotherham" {
            return "Rotherham United"
        } else if team == "Wigan" {
            return "Wigan Athletic"
        } else if team == "Colchester Utd" {
            return "Colchester United"
        } else {
            return team
        }
    }
}
