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
            donaterNameField.text = donatedItem.businessName
            
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
            if let coor = donatedItem.coordinates {
                mapView.setCenter(coor, animated: true)
            }
            
            centerMap((donatedItem.coordinates)!)
            
        }
        else{
            print("ERROR: DATA NOT LOADING")
        }
 
    }
    
    //MARK: MAP
    
    func centerMap(_ center:CLLocationCoordinate2D){
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
 
    //MARK: Actions
    @IBAction func reserveSwitched(_ sender: AnyObject) {
        
        if reserveSwitch.isOn {
            reserved = true
            if (donatedItem?.reserveItem())! {
                checkSwitch()
            } else {
                let alert = UIAlertController(title: "Already Reserved", message: "We're sorry, this item has already been reserved by another user.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                checkSwitch()
            }
            
        } else {
            
            reserved = false
            donatedItem?.unreserveItem()
            checkSwitch()
            
        }
        
    }
    
    //MARK: Functions
    
    func checkSwitch() {
        
        if reserved == true {
            
            reserveSwitch.isOn = true
            reserveSwitch.alpha = 0.3
            reserveLbl.text = "Reserved"
            
        } else {
            reserveSwitch.alpha = 1.0
            reserveLbl.text = "Reserve"
            
        }
        
    }

}
