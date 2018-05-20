//
//  OverlayView.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/26/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit
import EVSlidingTableViewCell

protocol MyProtocol {
    var name: String { get }
}

struct MyStruct: MyProtocol {
    let name: String
}

class OverlayViewWrapper<T: MyProtocol>: EVOverlayView<T> {
    lazy var view: OverlayView = {
        return OverlayView.loadFromNib(nil)
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI(){
        view.titleLabel.text = viewParameters?.name
    }
    
    deinit {
        viewParameters = nil
    }
}

class OverlayView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
