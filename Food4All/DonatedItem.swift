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


class DonatedItem {
    
    fileprivate var _name: String!
    fileprivate var _description: String!
    fileprivate var _expiration: String!
    
    
    var ref: FIRDatabaseReference!
    
    
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var expiration: String {
        if _expiration == nil {
            _expiration = ""
        }
        return _expiration
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
