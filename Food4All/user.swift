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
        let user = FIRAuth.auth()?.currentUser
        
        self.buisnessName = "SHITTY COMICS";
        self.email = (user?.email)!;
        self.userID = (user?.uid)!;

    }
}
