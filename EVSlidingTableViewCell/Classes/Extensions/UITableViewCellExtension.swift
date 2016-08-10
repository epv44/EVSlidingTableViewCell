//
//  UITableViewCellExtension.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/26/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

extension UITableViewCell {
    private struct AssociatedKeys {
        static var drawerDisplayed: Bool = false
    }
    
    var drawerDisplayed : Bool! {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.drawerDisplayed) as? Bool)
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.drawerDisplayed, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
