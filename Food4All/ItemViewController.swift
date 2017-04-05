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
    @IBOutlet weak var reserveLbl: UILabel!
    
    
    @IBOutlet weak var descriptionField: UILabel!
    @IBOutlet weak var availableDateField: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var expiryDateLabel: UILabel!
    
    //Variables
    var donatedItem: DonatedItem?
    var userID: String?
    var reserverID: String?
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var myLocation: CLLocationCoordinate2D?
    var mapData: MapData?
    var reserved: Bool?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        //delegates
        
        if let donatedItem = donatedItem {
            titleLabel.text = donatedItem.name
            image.image = donatedItem.image!
            
            //TODO: Load user name
            donaterNameField.text = donatedItem.name

            
            descriptionField.text = donatedItem.description
            
            reserved = donatedItem.reserved
            
            checkSwitch()
 
            
            let formatter = DateFormatter()
            
            //convert the date string back to a date object
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let expDate = formatter.date(from: donatedItem.expiration)
            
            //convert the date to an easy to read format
            formatter.dateFormat = "MMMM dd, YYYY, h:mm a"
            
            expiryDateLabel.text = formatter.string(from: expDate!)
            
            
            
        //TODO: - Add field to item model for reserve and business name (linked to account)
        //TODO: lock the reserve switch if you are not the user who reserved it or the user who created the item
            
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
           // annotation.coordinate = donatedItem.coordinates!
            //mapView.addAnnotation(annotation)
            
            let address = donatedItem.address
            
            //convert address to coordinates
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address!) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        // handle no location found
                        return
                }
                
                annotation.coordinate = location.coordinate
                self.mapView.addAnnotation(annotation)
            }
            
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
    
    //MARK: Actions
    @IBAction func reserveSwitched(_ sender: AnyObject) {
        
        if reserveSwitch.isOn {
            reserved = true
            checkSwitch()
            donatedItem?.reserveItem()
        } else {
            
            reserved = false
            checkSwitch()
            
        }
        
    }
    
    //MARK: Functions
    
    func checkSwitch() {
        
        if reserved == true {
            
            reserveSwitch.isOn = true
            reserveSwitch.isUserInteractionEnabled = false
            reserveSwitch.alpha = 0.3
            reserveLbl.text = "Reserved"
            
        } else {
            
            reserveSwitch.isUserInteractionEnabled = true
            reserveSwitch.alpha = 1.0
            reserveLbl.text = "Reserve"
            
        }
        
    }

}
