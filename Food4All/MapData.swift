//
//  MapData.swift
//  Food4All
//
//  Created by Shane Mckenzie on 3/14/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MapData {
    
    
    
    
    
    func loadSampleData(_ mapView: MKMapView) {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: 50.417433, longitude: -104.594178)
        
        mapView.addAnnotation(annotation)
        
    }
}
