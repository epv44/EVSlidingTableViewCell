//
//  UIViewLoading.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/25/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

public protocol UIViewLoading {}

extension UIView : UIViewLoading {}

public extension UIViewLoading where Self : UIView {
    static func loadFromNib(bundle: NSBundle?) -> Self {
        let nibName = "\(self)".characters.split(".").map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil).first as! Self
    }
}
