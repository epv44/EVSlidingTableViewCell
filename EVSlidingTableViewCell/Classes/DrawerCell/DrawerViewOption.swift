//
//  DrawerViewOption.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/25/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import Foundation

public struct DrawerViewOption {
    private var labelText: String = String()
    private var associateContactValue: String = String()
    private var iconLiteral: String = String()
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
    
    public var textForLabel: String {
        get{
            return labelText
        }
        set(value){
            self.labelText = value
        }
    }
    
    //this should change to be a UIImage
    public var iconStringLiteral: String {
        get{
            return iconLiteral
        }
        set(value){
            self.iconLiteral = value
        }
    }
}