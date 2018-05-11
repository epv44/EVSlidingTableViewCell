//
//  OverlayView.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/26/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit
import EVSlidingTableViewCell

class OverlayView: EVOverlayView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private  weak var subtitleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setupUI(){
        titleLabel.text = viewParameters?["name"] as? String
    }
    
    deinit {
        viewParameters = nil
    }
}
