//
//  DrawerViewOption.swift
//  SlidingTableViewCell
///  Contains the settings used to create a Drawer View Button inside of the drawer view, when the overlay is swiped the drawer view is revealed and is populated based on the values contained here
//  Created by Eric Vennaro on 7/25/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import Foundation

public struct DrawerViewOption {
    private var labelText: String?
    private var associateContactValue: String?
    private var icon: UIImage?
    private var actionClosure: DrawerViewClosureType!
    
    ///initializer method
    public init(){
        
    }
    ///((String) -> Bool) closure executed on IBAction
    public var closure: DrawerViewClosureType! {
        get {
            return actionClosure
        }
        set(value){
            self.actionClosure = value
        }
    }
    ///String value that is passed into the closure as part of the IBAction
    public var valueForButtonAction: String? {
        get{
            return associateContactValue
        }
        set(value){
            self.associateContactValue = value ?? ""
        }
    }
    ///String label placed below the UIButton
    public var textForLabel: String? {
        get{
            return labelText
        }
        set(value){
            self.labelText = value ?? ""
        }
    }
    ///UIImage used by the UIButton.
    public var buttonImage: UIImage? {
        get{
            return icon
        }
        set(value){
            self.icon = value 
        }
    }
}