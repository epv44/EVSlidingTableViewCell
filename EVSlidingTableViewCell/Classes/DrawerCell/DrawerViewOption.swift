//
//  DrawerViewOption.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/25/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import Foundation

/**
 Contains the settings used to create a Drawer View Button inside of the drawer view, when the overlay is swiped the drawer view is revealed and is populated based on the values contained here
 */
public struct DrawerViewOption {
    var labelText: String
    var associateContactValue: String
    var icon: UIImage
    var actionClosure: DrawerViewClosureType
    
    ///Initializer
    public init(labelText: String, actionText: String, icon: UIImage, action: @escaping DrawerViewClosureType) {
        self.labelText = labelText
        self.associateContactValue = actionText
        self.icon = icon
        self.actionClosure = action
    }
}
