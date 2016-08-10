//
//  EVOverlay.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/28/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import Foundation

protocol EVOverlay{
    var parameters: OverlayDictionaryType? { get set }
    
    func setupUI()
}