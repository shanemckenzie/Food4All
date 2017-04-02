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
import os.log

class GPSViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var myLocation: CLLocationCoordinate2D?
    var mapData: MapData?
    var itemIndex = -1
    var isDataLoaded = false
    
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
        
//<<<<<<< Updated upstream
        //button for slide out menu
        menuBtn.target = self.revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GPSViewController.repeatingMethod), userInfo: nil, repeats: true)
    }
    
    //MARK: ADD PINS TO MAP
    func repeatingMethod(){
        if(donatedItems.getCount() > 0 && !isDataLoaded)
        {
            addAnnotations()
        }
    }
    
    func addAnnotations(){
        for index in 0 ... (donatedItems.getCount() - 1){
            var annotation: CustomPin
            if(donatedItems.getItem(index: index).donated == true){
                annotation = CustomPin(color: "green", coordinate: donatedItems.getItem(index: index).coordinates!)
            }
            else{
                annotation = CustomPin(color: "red", coordinate: donatedItems.getItem(index: index).coordinates!)
            }
            
            mapView.addAnnotation(annotation)
        }
        isDataLoaded = true
    }
    
    //Check pin color attribure and set color accordingly
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        //let customAnnotation = CustomPin(color: "red", coordinate: annotation.coordinate)
        if let customAnnotation = annotation as? CustomPin {
        
            let annotationView = MKPinAnnotationView(annotation: customAnnotation, reuseIdentifier: "pin")
    
            if(customAnnotation.color == "green"){
                annotationView.pinTintColor = MKPinAnnotationView.greenPinColor()
            }
            else{
                annotationView.pinTintColor = MKPinAnnotationView.redPinColor()
            }
            return annotationView
        }
        return nil
    }
    
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let identifier = "pin"
        let annotation = MKPointAnnotation()
        annotation.coordinate = donatedItems.getItem(index: 0).coordinates!
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        for index in 0 ... (donatedItems.getCount() - 1){
            if(donatedItems.getItem(index: index).donated == true){
                annotationView.pinTintColor = MKPinAnnotationView.greenPinColor()
            }
            else{
                
            }
        }
        
        return annotationView
    }
    */
//=======
//        //load pins onto the map
//        
//
//        if donatedItems.getCount() != 0 {
//            for index in 0 ... (donatedItems.getCount() - 1){
//                //var view : MKPinAnnotationView
//             
////                if donatedItems.getItem(index: index).donated == true {
////                    let annotation = ColorPointAnnotation(pinColor: UIColor.green)
////                    annotation.pinColor = UIColor.green
////                    annotation.coordinate = donatedItems.getItem(index: index).coordinates!
////                    print(donatedItems.getItem(index: index).coordinates!)
////                    
////                } else {
////                    let annotation = ColorPointAnnotation(pinColor: UIColor.green)
////                    annotation.pinColor = UIColor.green
////                    annotation.coordinate = donatedItems.getItem(index: index).coordinates!
////                    print(donatedItems.getItem(index: index).coordinates!)
////                }
//                print(index)
//                let annotation = ColorPointAnnotation(pinColor: UIColor.green)
//                annotation.pinColor = UIColor.green
//                annotation.coordinate = donatedItems.getItem(index: index).coordinates!
//                print(donatedItems.getItem(index: index).coordinates!)
//            
//                mapView.addAnnotation(annotation)
//            }
//
//            //button for slide out menu
//            menuBtn.target = self.revealViewController()
//            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
//            
//        }
//    }
//    
//    //override func viewW
//    
//    //MARK: COLOR
////    
////    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        /*var view : MKPinAnnotationView
//        
//        guard let annotation = annotation as? PizzaLocation else {return nil}
//        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotation.identifier) as? MKPinAnnotationView {
//            view = dequeuedView
//        }else {
//            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
//        }
//        view.pinTintColor = pinColor(annotation.title!)
//        return view*/
////
////        if !(annotation is MKPointAnnotation) {
////            return nil
////        }
////        
////        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "colour")
////        
////        if annotationView == nil {
////            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "colour")
////            annotationView!.canShowCallout = true
////        } else {
////            annotationView!.annotation = annotation
////        }
////        
////        annotationView!.image = UIImage(named: "camera")
////        
////        return annotationView
////        
////    }
    
//>>>>>>> Stashed changes
    
    //MARK: PIN TAP
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        let currentAnnotation = view.annotation?.coordinate
        
        //find the donated item that corresponds with the pin that was tapped
        for index in 0 ... (donatedItems.getCount() - 1){
            
            
            if(compareCoordinates(c1: currentAnnotation!, c2: donatedItems.getItem(index: index).coordinates!)){
                itemIndex = index
                self.performSegue(withIdentifier: "mapShowItem", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue,sender: sender)
        
        switch(segue.identifier ?? "") {
        //the add item button is pressed
        case "AddItem":
            os_log("Adding a new donation.", log: OSLog.default, type: .debug)
            
        //an existing item is pressed
        case "mapShowItem":
            
            guard let itemViewController = segue.destination as? ItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let selectedDonation = donatedItems.getItem(index: itemIndex)
            
            itemViewController.donatedItem = selectedDonation
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
        
    }
    
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
