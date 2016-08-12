//
//  EVOverlayView.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 8/10/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

///  Base class for the view that overlay's the drawer view.  User's should extend this class and create their own Overlay view's.
public class EVOverlayView: UIView, EVOverlay {
    ///Dictionary of parameters [String:Any?] that the user should access inside the setupUI() method in order to set the layout for their cell
    public var viewParameters: OverlayDictionaryType?
    ///Stored property that updates the viewParameters and calls the setupUI() method
    public var parameters: OverlayDictionaryType? {
        didSet {
            viewParameters = parameters
            setupUI()
        }
    }
    ///method user should override in order to allow for a dynamic cell layout
    public func setupUI() {
        
    }
}
