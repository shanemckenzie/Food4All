//
//  ItemViewController.swift
//  Food4All
//
//  Created by bill on 3/16/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ItemViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //MARK: PROPERTIES
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var donaterNameField: UILabel!
    @IBOutlet weak var reserveSwitch: UISwitch!
    @IBOutlet weak var descriptionField: UILabel!
    @IBOutlet weak var availableDateField: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var expiryDateLabel: UILabel!
    
    //Variables
    var donatedItem: DonatedItem?
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var myLocation: CLLocationCoordinate2D?
    var mapData: MapData?
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        //delegates
        
        if let donatedItem = donatedItem {
            titleLabel.text = donatedItem.name
            image.image = donatedItem.image!
            donaterNameField.text = donatedItem.name
            descriptionField.text = donatedItem.description
            expiryDateLabel.text = donatedItem.expiration
            
            
            //MARK: TODO - Add field to item model for reserve and business name (linked to account)
            //TODO: lock the reserve switch if you are not the user who reserved it or the user who created the item
            //reserveSwitch.isUserInteractionEnabled = false
            
            //set up map
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
            
            mapView.delegate = self
            mapView.mapType = .standard
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true
            
            
            //add pin for current item location
            let annotation = MKPointAnnotation()
            annotation.coordinate = donatedItem.coordinates!
            mapView.addAnnotation(annotation)
            
            //center map on items location
            //mapView.setCenter(annotation.coordinate, animated: true)
            if let coor = donatedItem.coordinates {
                mapView.setCenter(coor, animated: true)
            }
            
        }
        else{
            print("ERROR: DATA NOT LOADING")
        }
 
    }
    
    //MARK: MAP
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        centerMap((donatedItem?.coordinates)!)
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        //self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        //guard let button = sender as? UIBarButtonItem, button === saveButton else {
          //  os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            //return
        //}
        
        //let name = nameTextField.text ?? "" //uses nil opeartor
        //let notes = notesField.text ?? ""
        //let photo = imageField.image
        //let dateEntered = Date()
        //let selectedPriority = priority[pickerView.selectedRow(inComponent: 0)]
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
       // item = Item(name: name, notes: notes, photo: photo, dateEntered: dateEntered, priority: selectedPriority, dueDate: myDueDate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
