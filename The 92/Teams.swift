//
//  Teams.swift
//  The 92
//
//  Created by Daniel Earl on 09/05/2024.
//  Copyright © 2024 Daniel Earl. All rights reserved.
//

import Foundation

class Teams: NSObject {
    static let shared = Teams()
    
    struct teamData {
        var teamName: String
        var stadiumName: String
        var stadiumLat: Double
        var stadiumLon: Double
        var is92: Bool
    }
    
    func loadTeamDetails(team: String) -> teamData {
        var stadiumName = ""
        var stadiumLat = 0.00
        var stadiumLon = 0.00
        var is92 = true
        
        if team == "Accrington Stanley" {
            stadiumName = "Wham Stadium"
            stadiumLat = 53.7645074
            stadiumLon = -2.3704834
        }
        else if team == "AFC Wimbledon" {
            stadiumName = "Plough Lane"
            stadiumLat = 51.431547
            stadiumLon = -0.186599
        }
        else if team == "Arsenal" {
            stadiumName = "The Emirates"
            stadiumLat = 51.5550526
            stadiumLon = -0.105846
        }
        else if team == "Aston Villa" {
            stadiumName = "Villa Park"
            stadiumLat = 52.5088714
            stadiumLon = -1.8848723
        }
        else if team == "Barnsley" {
            stadiumName = "Oakwell"
            stadiumLat = 53.5522662
            stadiumLon = -1.4686315
        }
        else if team == "Barrow" {
            stadiumName = "SO Legal Stadium"
            stadiumLat = 54.12330
            stadiumLon = -3.23494
        }
        else if team == "Birmingham City" {
            stadiumName = "St. Andrew's @ Knighthead Park"
            stadiumLat = 52.474486
            stadiumLon = -1.866873
        }
        else if team == "Blackburn Rovers" {
            stadiumName = "Ewood Park"
            stadiumLat = 53.7294672
            stadiumLon = -2.4881448
        }
        else if team == "Blackpool" {
            stadiumName = "Bloomfield Road"
            stadiumLat = 53.8041828
            stadiumLon = -3.0467969
        }
        else if team == "Bolton Wanderers" {
            stadiumName = "Toughsheet Community Stadium"
            stadiumLat = 53.5807096
            stadiumLon = -2.5366891
        }
        else if team == "Bournemouth" {
            stadiumName = "Vitality Stadium"
            stadiumLat = 50.734901
            stadiumLon = -1.8389888
        }
        else if team == "Bradford City" {
            stadiumName = "University of Bradford Stadium"
            stadiumLat = 53.8035782
            stadiumLon = -1.7594818
        }
        else if team == "Brentford" {
            stadiumName = "Gtech Community Stadium"
            stadiumLat = 51.490821
            stadiumLon = -0.288618
        }
        else if team == "Brighton & Hove Albion" {
            stadiumName = "The Amex"
            stadiumLat = 50.86185
            stadiumLon = -0.08248
        }
        else if team == "Bristol City" {
            stadiumName = "Ashton Gate"
            stadiumLat = 51.439884
            stadiumLon = -2.6210076
        }
        else if team == "Bristol Rovers" {
            stadiumName = "Memorial Stadium"
            stadiumLat = 51.4858436
            stadiumLon = -2.5835966
        }
        else if team == "Bromley" {
            stadiumName = "Hayes Lane Stadium"
            stadiumLat = 51.39031
            stadiumLon = 0.02117
        }
        else if team == "Burnley" {
            stadiumName = "Turf Moor"
            stadiumLat = 53.7884704
            stadiumLon = -2.2303248
        }
        else if team == "Burton Albion" {
            stadiumName = "Pirelli Stadium"
            stadiumLat = 52.821462
            stadiumLon = -1.6270024
        }
        else if team == "Cambridge United" {
            stadiumName = "Abbey Stadium"
            stadiumLat = 52.2121000
            stadiumLon = 0.1541300
        }
        else if team == "Cardiff City" {
            stadiumName = "Cardiff City Stadium"
            stadiumLat = 51.472830
            stadiumLon = -3.203030
        }
        else if team == "Carlisle United" {
            stadiumName = "Brunton Park"
            stadiumLat = 54.8958163
            stadiumLon = -2.9144752
        }
        else if team == "Charlton Athletic" {
            stadiumName = "The Valley"
            stadiumLat = 51.486687
            stadiumLon = 0.0358469
        }
        else if team == "Chelsea" {
            stadiumName = "Stamford Bridge"
            stadiumLat = 51.4820072
            stadiumLon = -0.1907663
        }
        else if team == "Cheltenham Town" {
            stadiumName = "The Completely-Suzuki Stadium"
            stadiumLat = 51.9055762
            stadiumLon = -2.0620928
        }
        else if team == "Chesterfield" {
            stadiumName = "SMH Group Stadium"
            stadiumLat = 53.25222
            stadiumLon = -1.42591
        }
        else if team == "Colchester United" {
            stadiumName = "JobServe Stadium"
            stadiumLat = 51.923364
            stadiumLon = 0.896093
        }
        else if team == "Coventry City" {
            stadiumName = "Coventry Building Society Arena"
            stadiumLat = 52.4482668
            stadiumLon = -1.497429
        }
        else if team == "Crawley Town" {
            stadiumName = "Broadfield Stadium"
            stadiumLat = 51.099568
            stadiumLon = -0.1953945
        }
        else if team == "Crewe Alexandra" {
            stadiumName = "Alexandra Stadium"
            stadiumLat = 53.0879308
            stadiumLon = -2.4361022
        }
        else if team == "Crystal Palace" {
            stadiumName = "Selhurst Park"
            stadiumLat = 51.3978941
            stadiumLon = -0.0859235
        }
        else if team == "Derby County" {
            stadiumName = "Pride Park"
            stadiumLat = 52.9146511
            stadiumLon = -1.448016
        }
        else if team == "Doncaster Rovers" {
            stadiumName = "Eco-Power Stadium"
            stadiumLat = 53.5097718
            stadiumLon = -1.1129534
        }
        else if team == "Everton" {
            stadiumName = "Goodison Park"
            stadiumLat = 53.4391966
            stadiumLon = -2.9670169
        }
        else if team == "Exeter City" {
            stadiumName = "St James Park"
            stadiumLat = 50.7297825
            stadiumLon = -3.5209573
        }
        else if team == "Fleetwood Town" {
            stadiumName = "Highbury Stadium"
            stadiumLat = 53.91651
            stadiumLon = -3.02478
        }
        else if team == "Fulham" {
            stadiumName = "Craven Cottage"
            stadiumLat = 51.4740754
            stadiumLon = -0.2215902
        }
        else if team == "Gillingham" {
            stadiumName = "Priestfield"
            stadiumLat = 51.3848726
            stadiumLon = 0.5597597
        }
        else if team == "Grimsby Town" {
            stadiumName = "Blundell Park"
            stadiumLat = 53.570247
            stadiumLon = -0.046709
        }
        else if team == "Harrogate Town" {
            stadiumName = "The Envirovent Stadium"
            stadiumLat = 53.99173
            stadiumLon = -1.51448
        }
        else if team == "Huddersfield Town" {
            stadiumName = "John Smiths Stadium"
            stadiumLat = 53.6540252
            stadiumLon = -1.7731935
        }
        else if team == "Hull City" {
            stadiumName = "MKM Stadium"
            stadiumLat = 53.7457315
            stadiumLon = -0.3680162
        }
        else if team == "Ipswich Town" {
            stadiumName = "Portman Road"
            stadiumLat = 52.0542255
            stadiumLon = 1.1447102
        }
        else if team == "Leeds United" {
            stadiumName = "Elland Road"
            stadiumLat = 53.7771779
            stadiumLon = -1.5715315
        }
        else if team == "Leicester City" {
            stadiumName = "King Power Stadium"
            stadiumLat = 52.6200439
            stadiumLon = -1.1414997
        }
        else if team == "Leyton Orient" {
            stadiumName = "Gaughan Group Stadium"
            stadiumLat = 51.5602116
            stadiumLon = -0.0118855
        }
        else if team == "Lincoln City" {
            stadiumName = "LNER Stadium"
            stadiumLat = 53.2181763
            stadiumLon = -0.540056
        }
        else if team == "Liverpool" {
            stadiumName = "Anfield"
            stadiumLat = 53.4316023
            stadiumLon = -2.9605416
        }
        else if team == "Luton Town" {
            stadiumName = "Kenilworth Road"
            stadiumLat = 51.8841800
            stadiumLon = -0.4316600
        }
        else if team == "Manchester City" {
            stadiumName = "Etihad Stadium"
            stadiumLat = 53.4838763
            stadiumLon = -2.1992886
        }
        else if team == "Manchester United" {
            stadiumName = "Old Trafford"
            stadiumLat = 53.4632114
            stadiumLon = -2.2911967
        }
        else if team == "Mansfield Town" {
            stadiumName = "Field Mill"
            stadiumLat = 53.1380700
            stadiumLon = -1.2007600
        }
        else if team == "Middlesbrough" {
            stadiumName = "Riverside Stadium"
            stadiumLat = 54.5781243
            stadiumLon = -1.2177641
        }
        else if team == "Millwall" {
            stadiumName = "The Den"
            stadiumLat = 51.4866709
            stadiumLon = -0.0510526
        }
        else if team == "MK Dons" {
            stadiumName = "Stadium MK"
            stadiumLat = 52.0093942
            stadiumLon = -0.7328938
        }
        else if team == "Morecambe" {
            stadiumName = "Mazuma Stadium"
            stadiumLat = 54.061180
            stadiumLon = -2.866935
        }
        else if team == "Newcastle United" {
            stadiumName = "St James Park"
            stadiumLat = 54.9752008
            stadiumLon = -1.622355
        }
        else if team == "Newport County" {
            stadiumName = "Rodney Parade"
            stadiumLat = 51.5882700
            stadiumLon = -2.9879900
        }
        else if team == "Northampton Town" {
            stadiumName = "Sixfields Stadium"
            stadiumLat = 52.0093942
            stadiumLon = -0.7328938
        }
        else if team == "Norwich City" {
            stadiumName = "Carrow Road"
            stadiumLat = 52.6223803
            stadiumLon = 1.308603
        }
        else if team == "Nottingham Forest" {
            stadiumName = "The City Ground"
            stadiumLat = 52.9394531
            stadiumLon = -1.1331991
        }
        else if team == "Notts County" {
            stadiumName = "Meadow Lane"
            stadiumLat = 52.94224
            stadiumLon = -1.13610
        }
        else if team == "Oxford United" {
            stadiumName = "Kassam Stadium"
            stadiumLat = 51.7175536
            stadiumLon = -1.2112956
        }
        else if team == "Peterborough United" {
            stadiumName = "Weston Homes Stadium"
            stadiumLat = 52.5652665
            stadiumLon = -0.2403379
        }
        else if team == "Plymouth Argyle" {
            stadiumName = "Home Park"
            stadiumLat = 50.3873937
            stadiumLon = -4.1517004
        }
        else if team == "Port Vale" {
            stadiumName = "Vale Park"
            stadiumLat = 53.0503903
            stadiumLon = -2.1916971
        }
        else if team == "Portsmouth" {
            stadiumName = "Fratton Park"
            stadiumLat = 50.7959228
            stadiumLon = -1.0648815
        }
        else if team == "Preston North End" {
            stadiumName = "Deepdale"
            stadiumLat = 53.7722293
            stadiumLon = -2.6893447
        }
        else if team == "Queens Park Rangers" {
            stadiumName = "MATRADE Loftus Road Stadium"
            stadiumLat = 51.510610
            stadiumLon = -0.230760
        }
        else if team == "Reading" {
            stadiumName = "Select Car Leasing Stadium"
            stadiumLat = 51.4223249
            stadiumLon = -0.9834968
        }
        else if team == "Rotherham United" {
            stadiumName = "AESSEAL New York Stadium"
            stadiumLat = 53.4296308
            stadiumLon = -1.3611662
        }
        else if team == "Salford City" {
            stadiumName = "Peninsula Stadium"
            stadiumLat = 53.51363
            stadiumLon = -2.27674
        }
        else if team == "Sheffield United" {
            stadiumName = "Bramall Lane"
            stadiumLat = 53.3698603
            stadiumLon = -1.4705122
        }
        else if team == "Sheffield Wednesday" {
            stadiumName = "Hillsborough"
            stadiumLat = 53.4116501
            stadiumLon = -1.5021879
        }
        else if team == "Shrewsbury Town" {
            stadiumName = "Croud Meadow"
            stadiumLat = 52.6884899
            stadiumLon = -2.7484126
        }
        else if team == "Southampton" {
            stadiumName = "St Marys Stadium"
            stadiumLat = 50.9065298
            stadiumLon = -1.3908231
        }
        else if team == "Stevenage" {
            stadiumName = "Lamex Stadium"
            stadiumLat = 51.8897477
            stadiumLon = -0.1920352
        }
        else if team == "Stockport County" {
            stadiumName = "Edgeley Park"
            stadiumLat = 53.39992
            stadiumLon = -2.16712
        }
        else if team == "Stoke City" {
            stadiumName = "bet365 Stadium"
            stadiumLat = 52.9891356
            stadiumLon = -2.1737192
        }
        else if team == "Sunderland" {
            stadiumName = "Stadium of Light"
            stadiumLat = 54.9147354
            stadiumLon = -1.3874242
        }
        else if team == "Swansea City" {
            stadiumName = "Swansea.com Stadium"
            stadiumLat = 51.6421561
            stadiumLon = -3.9351185
        }
        else if team == "Swindon Town" {
            stadiumName = "Country Ground"
            stadiumLat = 51.5647848
            stadiumLon = -1.7699336
        }
        else if team == "Tottenham Hotspur" {
            stadiumName = "Tottenham Hotspur Stadium"
            stadiumLat = 51.6031464
            stadiumLon = -0.0676001
        }
        else if team == "Tranmere Rovers" {
            stadiumName = "Prenton Park"
            stadiumLat = 53.3732067
            stadiumLon = -3.035836
        }
        else if team == "Walsall" {
            stadiumName = "Poundland Bescot Stadium"
            stadiumLat = 52.5655187
            stadiumLon = -1.991164
        }
        else if team == "Watford" {
            stadiumName = "Vicarage Road"
            stadiumLat = 51.6499300
            stadiumLon = -0.4015600
        }
        else if team == "West Bromwich Albion" {
            stadiumName = "The Hawthorns"
            stadiumLat = 52.5096036
            stadiumLon = -1.9638304
        }
        else if team == "West Ham United" {
            stadiumName = "The London Stadium"
            stadiumLat = 51.53867
            stadiumLon = -0.01649
        }
        else if team == "Wigan Athletic" {
            stadiumName = "The Brick Community Stadium"
            stadiumLat = 53.5471948
            stadiumLon = -2.6545159
        }
        else if team == "Wolverhampton Wanderers" {
            stadiumName = "Molineux"
            stadiumLat = 52.5908129
            stadiumLon = -2.130635
        }
        else if team == "Wrexham" {
            stadiumName = "STōK Cae Ras"
            stadiumLat = 53.05195
            stadiumLon = -3.00362
        }
        else if team == "Wycombe Wanderers" {
            stadiumName = "Adams Park"
            stadiumLat = 51.6311336
            stadiumLon = -0.7972369
        }
        else {
            is92 = false
        }
        
        return teamData(teamName: team, stadiumName: stadiumName, stadiumLat: stadiumLat, stadiumLon: stadiumLon, is92: is92)
    }
    
    /*  OLD GROUNDS
      "Oldham Athletic":[53.5543382,-2.1280832],"Oldham Athletic":"Boundary Park"
      "Scunthorpe Utd":[53.5872359,-0.6948787],"Scunthorpe Utd":"Sands Venue Stadium"
      "Hartlepool Utd":[54.68957,-1.21360],"Hartlepool Utd":"Victoria Park"
      "Rochdale":[53.6191217,-2.1800118],"Rochdale":"Crown Oil Arena"
      "Forest Green Rovers":[51.699104,-2.237933],"Forest Green Rovers":"The New Lawn"
      "Sutton Utd":[51.36759,-0.20429],"Sutton Utd":"VBS Community Stadium"
   */
}
