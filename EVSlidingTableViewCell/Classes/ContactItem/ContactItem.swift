//
//  ContactItem.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/25/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

class ContactItem: UIView {
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var itemContainer: UIView!
    
    private var closure: DrawerViewClosureType?
    private var actionText = ""
    
    var labelText: String? {
        get {
            return title.text
        }
        set {
            title.text = newValue
        }
    }
    
    var buttonClosure: DrawerViewClosureType? {
        get {
            return closure
        }
        set {
            closure = newValue
        }
    }
    
    var buttonActionText: String? {
        get {
            return actionText
        }
        set {
            actionText = newValue ?? ""
        }
    }
    
    var labelColor: UIColor? {
        get {
            return title.backgroundColor
        }
        set {
            title.backgroundColor = newValue
        }
    }
    
    var buttonImage: UIImage {
        get {
            return button.image(for: UIControlState()) ?? UIImage()
        }
        set {
            button.setImage(newValue, for: UIControlState())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func invokeContactClosure(_ sender: AnyObject) {
        _ = closure?(actionText)
    }
}
