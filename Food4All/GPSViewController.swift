//
//  GPSViewViewController.swift
//  Food4All
//
//  Created by Shane Mckenzie on 2/4/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ColorPointAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
}

class GPSViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var myLocation: CLLocationCoordinate2D?
    var mapData: MapData?
    
    //var annotations = [MKPointAnnotation]()
    var donatedItems = DonatedItems()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        donatedItems.initItems()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.mapView.showsUserLocation = true
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
//        let myLocation = locationManager.location!.coordinate
//        centerMap(myLocation)
        
        //centerMapOnLocation(location: locationManager.location?)
        //centerMapOnLocation(location: (locationManager.location)!)
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coor, animated: true)
        }
        
        //mapData?.loadSampleData(mapView)
        //let annotation = MKPointAnnotation()
        //annotation.coordinate = CLLocationCoordinate2D(latitude: 50.417433, longitude: -104.594179)
        //mapView.addAnnotation(annotation)
        
        //load pins onto the map
        
        for index in 0 ... (donatedItems.getCount() - 1){
            //var view : MKPinAnnotationView
         
            
            let annotation = ColorPointAnnotation(pinColor: UIColor.green)
            annotation.pinColor = UIColor.green
            annotation.coordinate = donatedItems.getItem(index: index).coordinates!
        
        
            mapView.addAnnotation(annotation)
        }

        //button for slide out menu
        menuBtn.target = self.revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        
    }
    
    //MARK: COLOR
    /*
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view : MKPinAnnotationView
        guard let annotation = annotation as? PizzaLocation else {return nil}
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotation.identifier) as? MKPinAnnotationView {
            view = dequeuedView
        }else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
        view.pinTintColor = pinColor(annotation.title!)
        return view
    }
    */
    
    //MARK: PIN TAP
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        //self.performSegue(withIdentifier: "logInSegue", sender: nil)
        let currentAnnotation = view.annotation?.coordinate
        
        //find the donated item that corresponds with the pin that was tapped
        for index in 0 ... (donatedItems.getCount() - 1){
            if(compareCoordinates(c1: currentAnnotation!, c2: donatedItems.getItem(index: index).coordinates!)){
                print("FOUND IT!!")
            }
        }
    }
    
    func compareCoordinates(c1: CLLocationCoordinate2D, c2: CLLocationCoordinate2D) -> Bool{
        if(c1.latitude == c2.latitude && c1.longitude == c2.longitude)
        {
            return true
        }
        else{
            return false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapView.showsUserLocation = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        var locValue:CLLocationCoordinate2D = manager.location.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        centerMap(locValue)
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        //self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }
    
    
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }

}
