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

class DonatedItems: NSObject{
    
    //MARK: Properties
    var donatedItems = [DonatedItem]()
    var isLoaded = false
    
    //MARK: Piblic functions
    
    func initItems(){
        loadSampleDonation()
        loadItems()
    }
    
    func getCount () -> Int{
        return donatedItems.count
    }
    
    

    func getItem(index: Int) -> DonatedItem{
        return donatedItems[index]
    }
    
    func addItem(item: DonatedItem){
        print("IM BEING ADDED")
        donatedItems.append(item)
    }
    
    
    //MARK: UPDATE FOR SORTING
    func updateItem(item: DonatedItem, index: Int){
        
        //remove item from index
        donatedItems.remove(at: index)
        
        //replace item at index
        donatedItems.append(item)
    }
    
    //TODO: Sorting by distance and date
    
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
                    let myImage = UIImage(named: "defaultPhoto")
                    
                    
                    let myDescription = donationItem.value(forKey: "description") as? String
                    let myDate = donationItem.value(forKey: "expiration") as? String
                    let myLatitude = donationItem.value(forKey: "latitude") as? Double
                    let myLongitude = donationItem.value(forKey: "longitude") as? Double
                    let myCoordinates = CLLocationCoordinate2D(latitude: myLatitude!, longitude: myLongitude!)
                    let myUserID = donationItem.value(forKey: "userID") as? String
                    let address = donationItem.value(forKey: "address") as? String
                    
                    
                    var  donated: Bool
                    if let donatedInt = donationItem.value(forKey: "donated") as? Int {
                        donated = Bool(donatedInt as NSNumber)
                    } else {
                        donated = true
                    }
                    
                    
                    //Messy ... clean up if time
                    let user = FIRAuth.auth()?.currentUser
                    
                    if(myUserID == user?.uid){
                        let donation1 = DonatedItem(myTitle, myImage!, donated, myDescription!, myDate!, myCoordinates, myUserID!, myItemID!, address!)
                        self.addItem(item: donation1!)
                    }
                
                }
                self.isLoaded = true
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    //MARK: Private Functions
    
    private func loadItems(){
        
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
                    let myImage = UIImage(named: "defaultPhoto")
                    
                    let myDescription = donationItem.value(forKey: "description") as? String
                    let myDate = donationItem.value(forKey: "expiration") as? String
                    let myLatitude = donationItem.value(forKey: "latitude") as? Double
                    let myLongitude = donationItem.value(forKey: "longitude") as? Double
                    let myCoordinates = CLLocationCoordinate2D(latitude: myLatitude!, longitude: myLongitude!)
                    let myUserID = donationItem.value(forKey: "userID") as? String
                    let myAddress = donationItem.value(forKey: "address") as? String
                    
                    
                    var  donated: Bool
                    if let donatedInt = donationItem.value(forKey: "donated") as? Int {
                        donated = Bool(donatedInt as NSNumber)
                    } else {
                        donated = true
                    }
                    
                    let donation1 = DonatedItem(myTitle, myImage!, donated, myDescription!, myDate!, myCoordinates, myUserID!, myItemID!, myAddress!)
                    self.addItem(item: donation1!)
                    
                    }
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
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
 
    
}
