//
//  SlidingTableViewControllerCell.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/25/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

public typealias OverlayDictionaryType = [String:Any?]
//Needs to change to DrawerViewOptionsType
public typealias ContactsArrayType = [DrawerViewOption]
public typealias DrawerViewClosureType = ((String) -> Bool)

public class SlidingTableViewControllerCell: UITableViewCell {
    @IBOutlet private weak var containerView: UIStackView!
    
    private var overlayViewGestureRecognizer = UIPanGestureRecognizer()
    private var drawerViewGestureRecognizer = UIPanGestureRecognizer()
    private var drawerBoxes: [ContactItem] = []
    private var originalCenter = CGPoint()
    private var contactMethods: ContactsArrayType?
    private var overlayView: EVOverlayView!
    private var growthRate: CGFloat = 0.01
    
    public func setCellWithAttributes(overlayParameters overlayParameters: OverlayDictionaryType, contactMethods: ContactsArrayType, overlayView overlay: EVOverlayView){
        self.contactMethods = contactMethods
        if overlayView == nil {
            overlayView = overlay
            overlayView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
            setupOverlayGestureRecognizer()
            setupDrawerViewGestureRecognizer()
            addSubview(overlayView)
        } else {
            overlayView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        }
        setupDrawerViewUI()
        overlayView.parameters = overlayParameters
    }
    
    //MARK: Gesture Handlers
    func handlePanFromOverlay(recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .Began:
            originalCenter = overlayView.center
            break
        case .Changed:
            let translation = recognizer.translationInView(overlayView)
            overlayView.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            for view in drawerBoxes {
                view.withdrawOverlay(translation: translation.x, width: overlayView.bounds.width, growthRate: growthRate)
                let range = self.frame.size.height - view.frame.size.height
                if range > 10 {
                    view.isPassed(translation: translation.x)
                }
            }
            break
        case .Ended:
            let translation = recognizer.translationInView(overlayView)
            let originalFrame = CGRectMake(0, 0, bounds.size.width, bounds.size.height)
            if(abs(translation.x) > overlayView.frame.size.width/4) {
                drawerDisplayed = true
                if isGoingLeft(translation.x) {
                    UIView.animateWithDuration(0.2,
                        animations: {
                            self.overlayView.frame.origin.x = -(self.frame.size.width + 10)
                        }
                    )
                } else {
                    UIView.animateWithDuration(0.2,
                        animations: {
                            self.overlayView.frame.origin.x = (self.frame.size.width + 10)
                        }
                    )
                }
                for view in drawerBoxes {
                    view.fadeAndTransform()
                }
            }else{
                drawerDisplayed = false
                UIView.animateWithDuration(0.2, animations: { self.overlayView.frame = originalFrame })
            }
            break
        default:
            break
        }
    }
    
    func handlePanFromDrawer(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state{
        case .Changed:
            let translation = recognizer.translationInView(self.overlayView)
            for view in drawerBoxes {
                view.replaceOverlay(translation: translation.x, width: overlayView.bounds.width, growthRate: growthRate)
            }
            let xPosition = isGoingLeft(translation.x) ? overlayView.bounds.origin.x + overlayView.frame.width : overlayView.bounds.origin.x - overlayView.frame.width
            overlayView.frame = CGRectMake(xPosition + translation.x, 0, overlayView.frame.width, overlayView.frame.height)
            break
        case .Ended:
            UIView.animateWithDuration(0.5,
                animations: {
                    self.overlayView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
                }
            )
            drawerDisplayed = false
            break
        default:
            break
        }
    }
    
    override public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    //MARK: Private Methods
    private func setupDrawerViewUI(){
        //this could be expensive...
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        drawerBoxes.removeAll()
        if contactMethods != nil {
            for contactMethod in contactMethods! {
                let contactView = ContactItem.loadFromNib(NSBundle(forClass: SlidingTableViewControllerCell.classForCoder()))
                //load a UIImage which the user would input.  Can provide in sample project..
                contactView.buttonImage = UIImage(imageLiteral: contactMethod.iconStringLiteral)
                contactView.labelText = contactMethod.textForLabel
                contactView.buttonClosure = contactMethod.closure
                contactView.buttonActionText = contactMethod.valueForButtonAction
                containerView.addArrangedSubview(contactView)
                drawerBoxes.append(contactView)
            }
            setGrowthRate()
        }
    }
    
    private func setupOverlayGestureRecognizer() {
        overlayViewGestureRecognizer = UIPanGestureRecognizer(target: self, action: .handlePanFromOverlay)
        overlayViewGestureRecognizer.delegate = self
        overlayView.addGestureRecognizer(overlayViewGestureRecognizer)
    }
    
    private func setupDrawerViewGestureRecognizer() {
        drawerViewGestureRecognizer = UIPanGestureRecognizer(target:self, action: .handlePanFromDrawer)
        drawerViewGestureRecognizer.delegate = self
        addGestureRecognizer(drawerViewGestureRecognizer)
    }
    
    private func roundToPlaces(value: Double, places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ceil(value * divisor) / divisor
    }
    
    private func setGrowthRate() {
        let numberOfDrawerBoxes = drawerBoxes.count
        if( numberOfDrawerBoxes != 0){
            let rawRate = Double((1.0 / (UIScreen.mainScreen().bounds.width / CGFloat(numberOfDrawerBoxes))))
            growthRate = CGFloat(roundToPlaces(rawRate, places: 3))
        }
    }
}

// MARK: Selector
private extension Selector {
    static let handlePanFromOverlay = #selector(SlidingTableViewControllerCell.handlePanFromOverlay(_:))
    static let handlePanFromDrawer = #selector(SlidingTableViewControllerCell.handlePanFromDrawer(_:))
}

// MARK: UIView
private extension UIView {
    var leftPosition: CGFloat { return (self.center.x - (self.frame.width / 2)) }
    var rightPosition: CGFloat { return (self.center.x + (self.frame.width / 2)) }
    
    func fadeAndTransform(changeFactor: CGFloat = 1.0) {
        self.alpha = changeFactor < 0.3 ? 0.3 : changeFactor
        self.transform = CGAffineTransformMakeScale(changeFactor, changeFactor)
    }
    
    func setStartingState(alphaValue: CGFloat = 0.0, transformValue: CGFloat = 0.2) {
        self.alpha = alphaValue
        self.transform = CGAffineTransformMakeScale(transformValue, transformValue)
    }
    
    func withdrawOverlay(translation translation: CGFloat, width: CGFloat, growthRate: CGFloat) {
        if isGoingLeft(translation){
            if case ((self.leftPosition) - ScalingConstants.buffer) ... self.rightPosition = (translation + width){
                let growthFactor = calculateGrowthFactorFor(translation: translation, boundsPosition: (width - (self.rightPosition + ScalingConstants.offset)), growthRate: growthRate)
                if growthFactor < ScalingConstants.growthFactorLimit{
                    self.fadeAndTransform(growthFactor)
                }
                if growthFactor > ScalingConstants.growthFactorLimit{
                    self.fadeAndTransform()
                }
            }
        } else {
            if case self.leftPosition ... (self.rightPosition + ScalingConstants.buffer) = translation{
                let growthFactor = calculateGrowthFactorFor(translation: translation, boundsPosition: (self.leftPosition - ScalingConstants.offset), growthRate: growthRate)
                if growthFactor < ScalingConstants.growthFactorLimit {
                    self.fadeAndTransform(growthFactor)
                }
                if growthFactor > ScalingConstants.growthFactorLimit {
                    self.fadeAndTransform()
                }
            }
        }
    }
    
    func isPassed(translation translation: CGFloat){
        if isGoingLeft(translation){
            if (leftPosition - ScalingConstants.offset) > (translation + UIScreen.mainScreen().bounds.width) {
                self.fadeAndTransform()
            }
        } else {
            if (rightPosition + ScalingConstants.offset) < translation {
                self.fadeAndTransform()
            }
        }
    }
    
    func replaceOverlay(translation translation: CGFloat, width: CGFloat, growthRate: CGFloat) {
        if isGoingLeft(translation) {
            if case self.leftPosition ... (self.rightPosition + ScalingConstants.buffer) = (width + translation){
                let growthFactor = 1 - calculateGrowthFactorFor(translation: translation, boundsPosition: (width - (self.rightPosition + ScalingConstants.offset)), growthRate: growthRate)
                if growthFactor < ScalingConstants.growthFactorLimit {
                    self.fadeAndTransform(growthFactor)
                }
                if growthFactor > ScalingConstants.growthFactorLimit {
                    self.fadeAndTransform()
                }
            }
        }else{
            if case self.leftPosition ... (self.rightPosition + ScalingConstants.buffer) = translation{
                let growthFactor = 1 - calculateGrowthFactorFor(translation: translation, boundsPosition: (self.leftPosition - ScalingConstants.offset), growthRate: growthRate)
                self.fadeAndTransform(growthFactor)
            }
        }
    }
    
    private func isGoingLeft(value: CGFloat) -> Bool{
        return value < 0 ? true : false
    }
    
    private func calculateGrowthFactorFor(translation translation: CGFloat, boundsPosition: CGFloat, growthRate: CGFloat) -> CGFloat {
        let growth = (((abs(translation) - boundsPosition)) * growthRate)
        if growth >= 1.0 {
            return 1.0
        } else if growth < 1.0 && growth > 0.0{
            return growth
        } else{
            return 0.0
        }
    }
}
