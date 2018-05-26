//
//  UIViewAutolayout.swift
//  EVSlidingTableViewCell
//
//  Created by Eric Vennaro on 5/22/18.
//

import UIKit

extension UIView {
    func pinTo(view: UIView) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
