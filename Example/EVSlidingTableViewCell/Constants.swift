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
                       User(name: "eric")]
}

func emailClosure() -> DrawerViewClosureType {
    func openEmail(text: String) -> (Bool) {
        UIApplication.sharedApplication().openURL(NSURL(string: "mailto:\(text)")!)
        return true
    }
    
    return openEmail
}


func phoneClosure() -> DrawerViewClosureType {
    func openPhone(text: String) -> (Bool) {
        let phoneNumber: String = text.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber)")!)
        return true
    }
    
    return openPhone
}

func textClosure() -> DrawerViewClosureType {
    func openMessenger(text: String) -> (Bool) {
        let phoneNumber = text.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        UIApplication.sharedApplication().openURL(NSURL(string: "sms:+\(phoneNumber)")!)
        return true
    }
    
    return openMessenger
}
