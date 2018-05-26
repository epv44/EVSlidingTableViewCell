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
    
    /**
     Set UIAttributes for DrawerView, establish gesture recognizers, and add the user defined overlay to the drawer.
     
     - Parameter labelText: String value that is passed into the closure as part of the IBAction
     - Parameter actionText: String value that is passed into the closure as part of the IBAction
     - Parameter icon: UIImage used by the UIButton.
     - Parameter action: ((String) -> Bool) closure executed on IBAction
     */
    public init(labelText: String, actionText: String, icon: UIImage, action: @escaping DrawerViewClosureType) {
        self.labelText = labelText
        self.associateContactValue = actionText
        self.icon = icon
        self.actionClosure = action
    }
}
