//
//  DonatedItems.swift
//  Food4All
//
//  Created by bill on 3/16/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import CoreLocation
import Foundation
import Firebase
import FirebaseAuth
import MapKit
import FirebaseStorage

class DonatedItems: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //MARK: Properties
    var donatedItems = [DonatedItem]()
    var isLoaded = false
    private let locationManager = CLLocationManager()
    
    //for removal of expired posts
    let currentDate = Date()
    
    
    //MARK: Public functions
    
    func initItems(){
        //loadSampleDonation()
        print("CALLING LOAD")
        loadItems()
    }
    
    func reInitItems(){
        donatedItems.removeAll()
        loadItems()
    }
    
    func getCount () -> Int{
        return donatedItems.count
    }
    
    func setIsLoaded(setIsLoaded: Bool){
        isLoaded = setIsLoaded
    }

    func isLDataLoaded() -> Bool{
        return isLoaded
    }
    
    func getItem(index: Int) -> DonatedItem{
        return donatedItems[index]
    }
    
    func addItem(item: DonatedItem){
        print("IM BEING ADDED")
        donatedItems.append(item)
    }
    
    
    //pass in the item id
    func deleteFromDb(itemToRemove: String) {
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        ref.child("DonationItem").child(itemToRemove).removeValue()
        
    }
    
    
    //MARK: UPDATE FOR SORTING
    func updateItem(item: DonatedItem, index: Int){
        
        //remove item from index
        donatedItems.remove(at: index)
        
        //replace item at index
        donatedItems.append(item)
    }

    func updateItem(newItem: DonatedItem){
        print("NEWUPDATE")
        print(newItem.name)
        //find item in array and update it
        var index = 0
        print("SIZE OF ITEMS")
        print(donatedItems.count)
        for item in donatedItems{
            print("MOVING ITEM")
            print(item.name)
            if (item.itemID == newItem.itemID)
            {
                donatedItems.remove(at: index)
                donatedItems.append(newItem)
            }
            index += 1
        }
    }
    
    //MARK: SORTING
    func sortByDate(){
        donatedItems.sort(by: {$0.expiration.compare($1.expiration) == .orderedAscending})
    }
    
    func sortByDistance(){
        let geoCoder = CLGeocoder()
        
        //get users location
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        let myLocation = locationManager.location
        print("MYLOCATION")
        print(myLocation)
        //measure distance between point and user and record
        for item in donatedItems{
            print("ITEMS LOCATION")
            print(item.coordinates)
            let itemsLocation = CLLocation(latitude: (item.coordinates?.latitude)!, longitude: (item.coordinates?.longitude)!)
            
            //FIXME: app occassionally crashing here, may just be simulator
            if(myLocation != nil) //does this help?
            {
                item.distanceFromUser = (myLocation?.distance(from: itemsLocation))!
            }
            else
            {
                item.distanceFromUser = 0
            }
        }
        self.donatedItems.sort(by: {$0.distanceFromUser < $1.distanceFromUser})
        for item in donatedItems{
            print(item.distanceFromUser)
        }
    }
    
    //MARK: CLEANUP
    func loadUsersItems(){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        ref.child("DonationItem").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let values = snapshot.value as? NSDictionary {
                
                for (key,_) in values{
                    
                    let donationItem: NSObject = values[key] as! NSObject
                    
                    let myTitle: String! = donationItem.value(forKey: "title") as? String
                    let myItemID: String! = donationItem.value(forKey: "itemID") as? String
                    
                    //let myPhotoString = donationItem.value(forKey: "image") as? String
                    //let decodedData = NSData(base64Encoded: myPhotoString!)
                    //let myImage = UIImage(data: decodedData as! Data)
                    
                    let myDescription = donationItem.value(forKey: "description") as? String
                    let myDate = donationItem.value(forKey: "expiration") as? String
                    let myLatitude = donationItem.value(forKey: "latitude") as? Double
                    let myLongitude = donationItem.value(forKey: "longitude") as? Double
                    let myCoordinates = CLLocationCoordinate2D(latitude: myLatitude!, longitude: myLongitude!)
                    let myUserID = donationItem.value(forKey: "userID") as? String
                    let address = donationItem.value(forKey: "address") as? String
                    let reservedBy = donationItem.value(forKey: "reservedBy") as? String
                    
                    
                    var  donated: Bool
                    if let donatedInt = donationItem.value(forKey: "donated") as? Int {
                        donated = Bool(donatedInt as NSNumber)
                    } else {
                        donated = true
                    }
                    
                    var  reserved: Bool
                    if let reservedInt = donationItem.value(forKey: "reserved") as? Int {
                        reserved = Bool(reservedInt as NSNumber)
                    } else {
                        reserved = true
                    }
                    
                    //Messy ... clean up if time
                    let user = FIRAuth.auth()?.currentUser
                    
                    if(myUserID == user?.uid){
                        
                        //---Load image from storage rather than db
                        
                        // Get a reference to the storage service using the default Firebase App
                        let storage = FIRStorage.storage()
                        let storageRef = storage.reference()
                        
                        // Create a reference to the file you want to download
                        let url = "images/" + myItemID + ".jpg"
                        let imageRef = storageRef.child(url)
                        
                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        var myImage: UIImage?
                        
                        imageRef.data(withMaxSize: 1 * 1024 * 1024)
                        { (data, error) -> Void in
                            if (error != nil) {
                                print("STORAGE ERROR")
                                print(error)
                            }
                            else
                            {
                                myImage = UIImage(data: data!)
                                if(myImage == nil)
                                {
                                    myImage = UIImage(named: "defaultPhoto")
                                }
                                
                                let donation1 = DonatedItem(myTitle, myImage!, donated, myDescription!, myDate!, myCoordinates, myUserID!, myItemID!, address!, reserved: reserved, reservedBy: reservedBy!)
                                self.addItem(item: donation1!)
                            }
                        }
                    }
                    
                }
                
            }
            
            
        }) { (error) in
            print("Failed to load from FireBase")
        }
        
    }
    
    //MARK: Private Functions
    
    private func loadItems(){
        print("INSIDE LOAD FUNCTION")
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let formatter = DateFormatter()
        
        ref.child("DonationItem").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let values = snapshot.value as? NSDictionary
            {
                print("AM I ALIVE?")
                for (key,_) in values
                {
                    
                    let donationItem: NSObject = values[key] as! NSObject
                    let myItemID: String! = donationItem.value(forKey: "itemID") as? String
                    
                    let myDate = donationItem.value(forKey: "expiration") as? String
                    
                //If date is past, delete from DB, otherwise load the rest of the data
                    //convert the date string back to a date object for comparison
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    let expDate = formatter.date(from: myDate!)!
                    
                    print("EXPIRING \(expDate)")
                    
                    print("Current Date: \(self.currentDate)")
                    print("Exp Date: \(expDate)")
                    
                    let calendar = NSCalendar.current
                    
                    
                    let currDay = calendar.startOfDay(for: self.currentDate)
                    let expDay = calendar.startOfDay(for: expDate)
                    
                    
                    
                
                    if /*expDate < self.currentDate*/expDay < currDay {
                        //removes items
                        self.deleteFromDb(itemToRemove: myItemID)
                        print("DELETING \(myItemID)")
                      
                    } else {
                    
                        let myTitle: String! = donationItem.value(forKey: "title") as? String
                        
                        //let myPhotoString = donationItem.value(forKey: "image") as? String
                        //let decodedData = NSData(base64Encoded: myPhotoString!)
                        //let myImage = UIImage(data: decodedData as! Data)
                        
                        let myDescription = donationItem.value(forKey: "description") as? String
                        
                        let myLatitude = donationItem.value(forKey: "latitude") as? Double
                        let myLongitude = donationItem.value(forKey: "longitude") as? Double
                        let myCoordinates = CLLocationCoordinate2D(latitude: myLatitude!, longitude: myLongitude!)
                        let myUserID = donationItem.value(forKey: "userID") as? String
                        let myAddress = donationItem.value(forKey: "address") as? String
                        let reservedBy = donationItem.value(forKey: "reservedBy") as? String
                        
                        
                        var  donated: Bool
                        if let donatedInt = donationItem.value(forKey: "donated") as? Int {
                            donated = Bool(donatedInt as NSNumber)
                        }
                        else {
                            donated = true
                        }
                        
                        var  reserved: Bool
                        if let reservedInt = donationItem.value(forKey: "reserved") as? Int {
                            reserved = Bool(reservedInt as NSNumber)
                        } else {
                            reserved = true
                        }
                        
                        //---Load image from storage rather than db
                        
                        // Get a reference to the storage service using the default Firebase App
                        let storage = FIRStorage.storage()
                        let storageRef = storage.reference()
                        
                        // Create a reference to the file you want to download
                        let url = "images/" + myItemID + ".jpg"
                        let imageRef = storageRef.child(url)
                        
                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        var myImage: UIImage?
                        
                        imageRef.data(withMaxSize: 1 * 1024 * 1024)
                        { (data, error) -> Void in
                            if (error != nil) {
                                print("STORAGE ERROR")
                                print(error)
                            }
                            else
                            {
                                myImage = UIImage(data: data!)
                                if(myImage == nil)
                                {
                                    myImage = UIImage(named: "defaultPhoto")
                                }
                                
                                let donation1 = DonatedItem(myTitle, myImage!, donated, myDescription!, myDate!, myCoordinates, myUserID!, myItemID!, myAddress!, reserved: reserved, reservedBy: reservedBy!)
                                self.addItem(item: donation1!)
                            }
                        }
                     
                    }
                }
            
            }
            
            
        }) { (error) in
            print("Failed to load from firebase db")
        }
        
    }
    
    
    /*
    private func loadSampleDonation() {
        
        let photo = UIImage(named: "defaultPhoto")
        let title = "Sample Donation"
        let description = "Sample donation description"
        let title2 = "Sample Donation Request"
        let description2 = "Requesting donations of ______"
        let date = NSDate()
        let date2 = NSDate(timeIntervalSinceNow: -50 * 2000)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, h:mm a"
        
        let dateString: String = formatter.string(from: date as Date)
        let dateString2: String = formatter.string(from: date2 as Date)
        let coordinates = CLLocationCoordinate2D(latitude: 50.417433, longitude: -104.594179)
        let coordinates2 = CLLocationCoordinate2D(latitude: 50.417439, longitude: -104.59417)
        let coordinates3 = CLLocationCoordinate2D(latitude: 50.495254, longitude: -104.637263)
        
        let user = FIRAuth.auth()?.currentUser
        
        guard let donation1 = DonatedItem(title, photo!, true, description, dateString, coordinates, (user?.uid)!, "123", "123") else {
            fatalError("Unable to instantiate object")
        }
        
        guard let donation2 = DonatedItem(title2, photo!, false, description2, dateString, coordinates2, (user?.uid)!, "123", "123") else {
            fatalError("Unable to instantiate object")
        }
        
        guard let donation3 = DonatedItem("WALMART", photo!, false, description2, dateString2, coordinates3, (user?.uid)!, "123", "123") else {
            fatalError("Unable to instantiate object")
        }
        
        
        donatedItems += [donation1, donation2, donation3]
        
        
    }
 */
    
}
