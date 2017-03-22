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
    
    //MARK: Piblic functions
    
    func initItems(){
        //loadSampleDonation()
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
    
    //MARK: Private Functions
    private func loadItems(){
        
        //NOTE!!!!!!!!!
        //TABLE VIEW IS BEING LOADED BEFORE ITEMS ARE RETRIEVED FROM DB
        
        //REMOVE--------------------------------
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
        
       
        /*
        guard let donation1 = DonatedItem(title, photo!, true, description, dateString, coordinates, (user?.uid)!) else {
            fatalError("Unable to instantiate object")
        }
        
        guard let donation2 = DonatedItem(title2, photo!, false, description2, dateString, coordinates2, (user?.uid)!) else {
            fatalError("Unable to instantiate object")
        }
        
        guard let donation3 = DonatedItem("WALMART", photo!, false, description2, dateString2, coordinates3, (user?.uid)!) else {
            fatalError("Unable to instantiate object")
         //donatedItems += [donation1, donation2, donation3]
        }
 */
         //REMOVE-----------------------------------------------
        
        var myArray = [DonatedItem]()
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        ref.child("DonationItem").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let values = snapshot.value as? NSDictionary
            
            for (key,_) in values!{
                
                let donationItem: NSObject = values![key] as! NSObject
                
                let myTitle: String! = donationItem.value(forKey: "title") as? String
                print("MY NAME IS")
                print(myTitle)
                let donation1 = DonatedItem(myTitle, photo!, true, description, dateString, coordinates, (user?.uid)!)
                self.addItem(item: donation1!)
                
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
       // let donation1 = DonatedItem(title, photo!, true, description, dateString, coordinates, (user?.uid)!)
       // myArray.append(donation1!)
       // donatedItems.append(donation1!)
        
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
        
        guard let donation1 = DonatedItem(title, photo!, true, description, dateString, coordinates, (user?.uid)!) else {
            fatalError("Unable to instantiate object")
        }
        
        guard let donation2 = DonatedItem(title2, photo!, false, description2, dateString, coordinates2, (user?.uid)!) else {
            fatalError("Unable to instantiate object")
        }
        
        guard let donation3 = DonatedItem("WALMART", photo!, false, description2, dateString2, coordinates3, (user?.uid)!) else {
            fatalError("Unable to instantiate object")
        }
        
        
        donatedItems += [donation1, donation2, donation3]
        
        
    }
    
    
}
