//
//  DonatedItem.swift
//  Food4All
//
//  Created by Shane Mckenzie on 1/26/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import Foundation

class DonatedItem {
    
    fileprivate var _name: String!
    fileprivate var _expiration: String!
    
    
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
    
}
