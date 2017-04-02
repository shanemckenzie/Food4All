//
//  CustomPin.swift
//  Food4All
//
//  Created by bill on 4/1/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import Foundation
import MapKit

class CustomPin: NSObject, MKAnnotation {
    let color: String
    let coordinate: CLLocationCoordinate2D
    
    init(color: String, coordinate: CLLocationCoordinate2D) {
        self.color = color
        self.coordinate = coordinate
        
        super.init()
    }
    
    // MARK: - MapKit related methods
    
    // pinTintColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    func pinTintColor() -> UIColor  {
        switch color {
        case "red":
            return MKPinAnnotationView.redPinColor()
        case "purple":
            return MKPinAnnotationView.purplePinColor()
        default:
            return MKPinAnnotationView.greenPinColor()
        }
    }
}
