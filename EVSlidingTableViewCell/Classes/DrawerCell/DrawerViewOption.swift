//
//  DrawerViewOption.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/25/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import Foundation

public struct DrawerViewOption {
    private var labelText: String?
    private var associateContactValue: String?
    private var icon: UIImage?
    private var actionClosure: DrawerViewClosureType!
    
    public init(){
        
    }
    
    public var closure: DrawerViewClosureType! {
        get {
            return actionClosure
        }
        set(value){
            self.actionClosure = value
        }
    }
    
    public var valueForButtonAction: String? {
        get{
            return associateContactValue
        }
        set(value){
            self.associateContactValue = value ?? ""
        }
    }
    
    public var textForLabel: String? {
        get{
            return labelText
        }
        set(value){
            self.labelText = value
        }
    }
    
    public var buttonImage: UIImage? {
        get{
            return icon
        }
        set(value){
            self.icon = value
        }
    }
}