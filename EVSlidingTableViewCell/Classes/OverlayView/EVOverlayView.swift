//
//  EVOverlayView.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 8/10/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

class EVOverlayView: UIView, EVOverlay {
    var viewParameters: OverlayDictionaryType?
    
    var parameters: OverlayDictionaryType? {
        didSet {
            viewParameters = parameters
            setupUI()
        }
    }
    
    func setupUI() {
        
    }
}
