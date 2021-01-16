//
//  StadiumMapAnnotation.swift
//  The 92
//
//  Created by Daniel Earl on 26/10/2020.
//  Copyright © 2020 Daniel Earl. All rights reserved.
//

import MapKit

class StadiumMapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let visitCount: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        visitCount: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.visitCount = visitCount
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return visitCount
    }
}
