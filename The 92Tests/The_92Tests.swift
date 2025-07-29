//
//  The_92Tests.swift
//  The 92Tests
//
//  Created by Daniel Earl on 29/05/2025.
//  Copyright © 2025 Daniel Earl. All rights reserved.
//

import Testing
@testable import The_92

struct The_92Tests {
    
    @Test("Premier Leauge Team Count") func checkNumberOfTeamsInPremierLeague() async throws {
        let teams = await StadiumTableViewController().premierLeagueTeams
        #expect(teams.count == 20)
    }

    @Test("Championship Team Count") func checkNumberOfTeamsInChampionship() async throws {
        let team = await StadiumTableViewController().championshipTeams
        #expect(team.count == 24)
    }
    
    @Test("League One Team Count") func checkNumberOfTeamsInLeagueOne() async throws {
        let team = await StadiumTableViewController().leagueOneTeams
        #expect(team.count == 24)
    }
    
    @Test("League Two Team Count") func checkNumberOfTeamsInLeagueTwo() async throws {
        let team = await StadiumTableViewController().leagueTwoTeams
        #expect(team.count == 24)
    }
}
