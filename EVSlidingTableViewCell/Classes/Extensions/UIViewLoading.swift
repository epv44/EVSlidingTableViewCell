//
//  UIViewLoading.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/25/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

///  Extension on UIView that allows for the easy loading of a UIView from a Nib.  Simply call your UIView and provide a NSBundle, nil is acceptable
public protocol UIViewLoading {}

extension UIView : UIViewLoading {}

public extension UIViewLoading where Self : UIView {
    /**
     Function that allows for a UIView to be loaded from a nib call YourView.loadFromNib(yourBundle)
     
     - Parameter bundle: NSBundle for the bundle the nib is in, nil is acceptable
     
     - Returns: The properly instantiated UINib
    */
    static func loadFromNib(bundle: NSBundle?) -> Self {
        let nibName = "\(self)".characters.split(".").map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil).first as! Self
    }
}
