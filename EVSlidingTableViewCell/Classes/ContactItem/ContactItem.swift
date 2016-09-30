//
//  ContactItem.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/25/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

class ContactItem: UIView {
    @IBOutlet fileprivate weak var button: UIButton!
    @IBOutlet fileprivate weak var title: UILabel!
    @IBOutlet weak var itemContainer: UIView!
    
    fileprivate var closure: DrawerViewClosureType?
    fileprivate var actionText: String?
    
    var labelText: String = "" {
        didSet {
            title.text = labelText
        }
    }
    
    var buttonClosure: DrawerViewClosureType? {
        didSet {
            closure = buttonClosure
        }
    }
    
    var buttonActionText: String? {
        didSet {
            actionText = buttonActionText ?? ""
        }
    }
    
    var labelColor: UIColor? {
        didSet {
            title.backgroundColor = labelColor
        }
    }
    
    var buttonImage: UIImage = UIImage() {
        didSet {
            button.setImage(buttonImage, for: UIControlState())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func invokeContactClosure(_ sender: AnyObject) {
        if closure != nil {
            guard closure!(actionText!) else {
                return
            }
        }
    }
}
