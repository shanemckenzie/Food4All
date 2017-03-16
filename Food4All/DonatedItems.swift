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
        loadSampleDonation()
    }
    
    func getCount () -> Int{
        return donatedItems.count
    }
    
    func getItem(index: Int) -> DonatedItem{
        return donatedItems[index]
    }
    
    func addItem(item: DonatedItem){
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
    private func loadSampleDonation() {
        
        let photo = UIImage(named: "defaultPhoto")
        let title = "Sample Donation"
        let description = "Sample donation description"
        let title2 = "Sample Donation Request"
        let description2 = "Requesting donations of ______"
        let date = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, h:mm a"
        
        let dateString: String = formatter.string(from: date as Date)
        let coordinates = CLLocationCoordinate2D(latitude: 50.417433, longitude: -104.594179)
        let coordinates2 = CLLocationCoordinate2D(latitude: 50.417439, longitude: -104.59417)
        let coordinates3 = CLLocationCoordinate2D(latitude: 50.495254, longitude: -104.637263)
        
        
        guard let donation1 = DonatedItem(title, photo!, true, description, dateString, coordinates) else {
            fatalError("Unable to instantiate object")
        }
        
        guard let donation2 = DonatedItem(title2, photo!, false, description2, dateString, coordinates2) else {
            fatalError("Unable to instantiate object")
        }
        
        guard let donation3 = DonatedItem("WALMART", photo!, false, description2, dateString, coordinates3) else {
            fatalError("Unable to instantiate object")
        }
        
        
        donatedItems += [donation1, donation2, donation3]
        
        
    }
    
    
}
