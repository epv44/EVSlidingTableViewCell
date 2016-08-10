//
//  EVOverlayView.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 8/10/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

public class EVOverlayView: UIView, EVOverlay {
    public var viewParameters: OverlayDictionaryType?
    
    public var parameters: OverlayDictionaryType? {
        didSet {
            viewParameters = parameters
            setupUI()
        }
    }
    
    public func setupUI() {
        
    }
}
