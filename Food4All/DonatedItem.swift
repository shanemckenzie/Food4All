//
//  DonatedItem.swift
//  Food4All
//
//  Created by Shane Mckenzie on 1/26/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import CoreLocation

class DonatedItem {
    
    fileprivate var _name: String!
    fileprivate var _description: String!
    fileprivate var _expiration: String!
    var donated: Bool!
    
    var image: UIImage?
    
    var expireDate: NSDate?
    var coordinates: CLLocationCoordinate2D?
    
    
    
    lazy var expireDateString: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, h:mm a"
        
        return formatter.string(from: self.expireDate as! Date)
    }()
    
    var ref: FIRDatabaseReference!

    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var expiration: String {
        if _expiration == nil {
            _expiration = ""
        }
        return _expiration
    }
    
    init?(){
        _name = ""
        _description = ""
        _expiration = ""
    }
    
    init?(_ title: String, _ image: UIImage, _ donated: Bool, _ description: String, _ expiration: String, _ coordinates: CLLocationCoordinate2D){
        
        self._name = title
        self.image = image
        self.donated = donated //true = item being donated, false = requesting donations
        self._description = description
        self._expiration = expiration
        self.coordinates = coordinates
        
    }
    
    
    func saveToDB() {
        ref = FIRDatabase.database().reference()
        
        let newDonationItemRef = self.ref!.child("DonationItem").childByAutoId()
        
        let newDonationItemId = newDonationItemRef.key
        
        let newDonationItemData: [String : Any] = ["itemID": newDonationItemId,
            "title": _name as NSString,
            "description": _description as NSString,
            "expiration": _expiration as NSString
            //user
            //image
            //location
        ]
        
        newDonationItemRef.setValue(newDonationItemData)
        
        
    }
    
}
