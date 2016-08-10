//
//  User.swift
//  EVSlidingTableViewCell
//
//  Created by Eric Vennaro on 8/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


struct User {
    var name: String?
    var email: String?
    var homePhone: String?
    var workPhone: String?
    
    init(name: String?, email: String?, homePhone: String?, workPhone: String?) {
        self.name = name
        self.email = email
        self.homePhone = homePhone
        self.workPhone = workPhone
    }
    
    init(name: String?, email: String?, homePhone: String?) {
        self.name = name
        self.email = email
        self.homePhone = homePhone
    }
    
    init(name: String?, email: String?, workPhone: String?) {
        self.name = name
        self.email = email
        self.workPhone = workPhone
    }
    
    init(name: String?, email: String?) {
        self.name = name
        self.email = email
    }
    
    init(name: String?) {
        self.name = name
    }
}