//
//  User.swift
//  Food4All
//
//  Created by bill on 3/19/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class User{
    
    //MARK USER PROPERTIES
    var userID: String
    var email: String
    var buisnessName: String
    
    //MARK: Initialization
    init?() {
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        let user = FIRAuth.auth()?.currentUser
        
        self.email = (user?.email)!;
        self.userID = (user?.uid)!;
        self.buisnessName = "N/A"
        ref.child("userMeta").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.buisnessName = value?["buisnessName"] as? String ?? ""
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //self.buisnessName = metaQuery->(buisnessName

    }
}
