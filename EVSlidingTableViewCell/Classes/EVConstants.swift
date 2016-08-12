//
//  ScalingConstants.swift
//  SlidingTableViewCell
//  Constants used by the application
//  Created by Eric Vennaro on 7/28/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

public struct EVConstants {
    //Bundle for the Cocoapod library
    public static let bundle = NSBundle(forClass: SlidingTableViewControllerCell.classForCoder())
    //UINib of the TableViewCell used by the Cocoapod library
    public static let evTableViewCell = UINib(nibName: "SlidingTableViewControllerCell", bundle: bundle)
    
    struct ScalingConstants {
        static let buffer: CGFloat = 40.0
        static let growthFactorLimit: CGFloat = 0.93
        static let offset: CGFloat = 20.0
        private static var growthRateValue: CGFloat = 0.01

        static var growthRate: CGFloat {
            get {
                return growthRateValue
            }
            set {
                self.growthRateValue = growthRate
            }
        }
    }
}