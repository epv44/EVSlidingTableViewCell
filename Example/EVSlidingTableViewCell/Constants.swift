//
//  Constants.swift
//  EVSlidingTableViewCell
//
//  Created by Eric Vennaro on 8/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.

import UIKit
import EVSlidingTableViewCell

struct Constants {
    static let data = [User(name: "tupac", email: "2pac@example.com", homePhone: "415-330-3433", workPhone: "415-330-2323"),
                       User(name: "richard", email: "mgk@example.com", homePhone: "216-000-0000", workPhone: "216-000-0000"),
                       User(name: "gerald", email: "g-eazy@example.com", homePhone: "510-111-1234", workPhone: "510-550-4345"),
                       User(name: "marshall", email: "eminem@example.com", homePhone: "313-233-3444"),
                       User(name: "scott", email: "kidcuddie@example.com", workPhone: "216-233-3444"),
                       User(name: "frank", email: "biggie@example.com"),
                       User(name: "darryl", email: "posk@example.com", homePhone: "347-330-3433", workPhone: "347-330-2323"),
                       User(name: "chris", email: "ludacris@example.com", homePhone: "216-000-0000", workPhone: "216-000-0000"),
                       User(name: "curtis", email: "50cent@example.com", homePhone: "347-111-1234", workPhone: "347-550-4345"),
                       User(name: "dwane", email: "wayne@example.com", homePhone: "313-233-3444"),
                       User(name: "bryan", email: "birdman@example.com", workPhone: "216-233-3444"),
                       User(name: "mario", email: "yogotti@example.com")
    ]
}

func emailClosure() -> DrawerViewClosureType {
    func openEmail(text: String) -> (Bool) {
        UIApplication.shared.openURL(NSURL(string: "mailto:\(text)")! as URL)
        return true
    }
    
    return openEmail
}


func phoneClosure() -> DrawerViewClosureType {
    func openPhone(text: String) -> (Bool) {
        let phoneNumber: String = text.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        UIApplication.shared.openURL(NSURL(string: "tel://\(phoneNumber)")! as URL)
        return true
    }
    
    return openPhone
}

func textClosure() -> DrawerViewClosureType {
    func openMessenger(text: String) -> (Bool) {
        let phoneNumber = text.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        UIApplication.shared.openURL(NSURL(string: "sms:+\(phoneNumber)")! as URL)
        return true
    }
    
    return openMessenger
}
