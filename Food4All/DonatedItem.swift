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
import FirebaseStorage


class DonatedItem {
    
    fileprivate var _name: String!
    fileprivate var _userID: String!
    fileprivate var _itemID: String!
    fileprivate var _description: String!
    fileprivate var _expiration: String!
    
    var address: String!
    var donated: Bool!
    var distanceFromUser = 0 as Double
    var reserved: Bool?
    var reservedBy: String?
    
    //TODO: the reserve switch on the item listing will check if the item has been reserved
    //if the item has been reserved, then only the reserver (and possibly the poster?) will be allowed to change it
    //var reserved: Bool!
    //var reservedBy: Bool!
    
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
    
    var userID: String {
        if _userID == nil {
            _userID = ""
        }
        return _name
    }
    
    var itemID: String {
        if _itemID == nil {
            _itemID = ""
        }
        return _itemID
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
        _userID = ""
        _itemID = ""
    }
    

    
    init?(_ title: String, _ image: UIImage, _ donated: Bool, _ description: String, _ expiration: String, _ coordinates: CLLocationCoordinate2D, _ userID: String, _ itemID: String, _ address: String, reserved: Bool, reservedBy: String){
        
        self._itemID = itemID
        self._name = title
        self._userID = userID
        self.image = image
        self.donated = donated //true = item being donated, false = requesting donations
        self._description = description
        self._expiration = expiration
        self.coordinates = coordinates
        self.address = address
        self.reserved = reserved
        self.reservedBy = reservedBy
        
        print("ASSIGNINGID")
        print(itemID)
    }
    
    func reserveItem(){
        let user = FIRAuth.auth()?.currentUser
        
        reserved = true
        reservedBy = user?.uid
        
        updateItem()
    }
    
    func updateItem(){
        print("WHATSMYID")
        print(self.itemID)
        ref = FIRDatabase.database().reference()
        let newDonationItemRef = self.ref!.child("DonationItem").child(self.itemID)
        //let newDonationItemId = newDonationItemRef.key
        let imageData = UIImagePNGRepresentation(self.image!)!
        var base64ImageString: NSString!
        base64ImageString = imageData.base64EncodedString() as NSString!
        
        let latitude = self.coordinates?.latitude
        let longitude = self.coordinates?.longitude
        
        let newDonationItemData: [String : Any] = ["itemID": self.itemID,
                                                   "title": _name as NSString,
                                                   "description": _description as NSString,
                                                   "expiration": _expiration as NSString,
                                                   "userID": _userID as NSString,
                                                   "image": base64ImageString as NSString,
                                                   "latitude": latitude! as NSNumber,
                                                   "longitude": longitude! as NSNumber,
                                                   "donated": Int(NSNumber(value:donated!)) as NSNumber,
                                                   "address": address! as NSString,
                                                   "reserved": Int(NSNumber(value:reserved!)) as NSNumber,
                                                   "reservedBy": reservedBy! as NSString
        ]
        
        newDonationItemRef.setValue(newDonationItemData)

    }
    
    func saveToDB() {
        
        ref = FIRDatabase.database().reference()
        let newDonationItemRef = self.ref!.child("DonationItem").childByAutoId()
        let newDonationItemId = newDonationItemRef.key

       // let imageData = UIImagePNGRepresentation(self.image!)!
        //var base64ImageString: NSString!
        //base64ImageString = imageData.base64EncodedString() as NSString!
        
        let latitude = self.coordinates?.latitude
        let longitude = self.coordinates?.longitude
        
        let newDonationItemData: [String : Any] = ["itemID": newDonationItemId,
            "title": _name as NSString,
            "description": _description as NSString,
            "expiration": _expiration as NSString,
            "userID": _userID as NSString,
            //"image": base64ImageString as NSString,
            "latitude": latitude! as NSNumber,
            "longitude": longitude! as NSNumber,
            "donated": Int(NSNumber(value:donated!)) as NSNumber,
            "address": address! as NSString,
            "reserved": Int(NSNumber(value:reserved!)) as NSNumber,
            "reservedBy": reservedBy! as NSString
        ]
        self._itemID = newDonationItemId
        newDonationItemRef.setValue(newDonationItemData)
        
        //----Upload image to firebase storage rather than db-----
        
        // Get a reference to the storage service using the default Firebase App
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to upload
        let url = "images/" + newDonationItemId + ".jpg"
        let imageRef = storageRef.child(url)
        
        // Upload the file to the path "images/rivers.jpg"
        let imageData = UIImageJPEGRepresentation(self.image!, 0.1)! //number refers to compression
        let uploadTask = imageRef.put(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
        }
    }
    
}
