//
//  SlidingTableViewControllerCell.swift
//  SlidingTableViewCell
///  UITableViewCell that takes a user defined overlay view and allows it to be "swiped" away revealing a serious of IBAction buttons.  As the drawer option buttons are revealed they grow and fade in. 
//  Created by Eric Vennaro on 7/25/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

public typealias OverlayDictionaryType = [String:Any?]
public typealias DrawerViewOptionsType = [DrawerViewOption]
public typealias DrawerViewClosureType = ((String) -> Bool)

public class SlidingTableViewControllerCell: UITableViewCell {
    @IBOutlet private weak var containerView: UIStackView!
    
    private var overlayViewGestureRecognizer = UIPanGestureRecognizer()
    private var drawerViewGestureRecognizer = UIPanGestureRecognizer()
    private var drawerBoxes: [ContactItem] = []
    private var originalCenter = CGPoint()
    private var drawerViewOptions: DrawerViewOptionsType?
    private var overlayView: EVOverlayView!
    private var growthRate: CGFloat = 0.01
    
    /**
     Set UIAttributes for DrawerView, establish gesture recognizers, and add the user defined overlay to the drawer.
        - Parameter overlayParameters: Dictionary with String key values that is passed to the user defined overlay upon setup.  Users should store any parameters they need to set the UI of their overlay and then access this dictionary inside the setupUI() method of their overlay.
        - Parameter drawerViewOptions: List of DrawerViewOption's which apply to the cell being set up.  These parameters are used to load the layout of the DrawerView options.
        - Parameter overlayView: User defined overlay for the cell, of type EVOverlayView which extends UIView
    */
    public func setCellWithAttributes(overlayParameters overlayParameters: OverlayDictionaryType, drawerViewOptions: DrawerViewOptionsType, overlayView overlay: EVOverlayView){
        self.drawerViewOptions = drawerViewOptions
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
        setGrowthRate()
        overlayView.parameters = overlayParameters
    }
    
    /** 
     Sets overlay to original center position, fully covering the drawer view.
    */
    public func resetOverlay(){
        overlayView.center = originalCenter
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
    
    //Set gesture recognizer to only pick up on horizontal swipes and allow for normal vertical scrolling of the UITableView
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
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        drawerBoxes.removeAll()
        if drawerViewOptions != nil && drawerViewOptions!.count < 5 {
            for option in drawerViewOptions! {
                let contactView = ContactItem.loadFromNib(NSBundle(forClass: SlidingTableViewControllerCell.classForCoder()))
                if let image = option.buttonImage {
                    contactView.buttonImage = image
                } else {
                    contactView.buttonImage = UIImage()
                }
                if let text = option.textForLabel {
                    contactView.labelText = text
                } else {
                    contactView.labelText = ""
                }
                contactView.buttonClosure = option.closure
                contactView.buttonActionText = option.valueForButtonAction
                containerView.addArrangedSubview(contactView)
                drawerBoxes.append(contactView)
            }
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
            if case ((self.leftPosition) - EVConstants.ScalingConstants.buffer) ... self.rightPosition = (translation + width){
                let growthFactor = calculateGrowthFactorFor(translation: translation, boundsPosition: (width - (self.rightPosition + EVConstants.ScalingConstants.offset)), growthRate: growthRate)
                if growthFactor < EVConstants.ScalingConstants.growthFactorLimit{
                    self.fadeAndTransform(growthFactor)
                }
                if growthFactor > EVConstants.ScalingConstants.growthFactorLimit{
                    self.fadeAndTransform()
                }
            }
        } else {
            if case self.leftPosition ... (self.rightPosition + EVConstants.ScalingConstants.buffer) = translation{
                let growthFactor = calculateGrowthFactorFor(translation: translation, boundsPosition: (self.leftPosition - EVConstants.ScalingConstants.offset), growthRate: growthRate)
                if growthFactor < EVConstants.ScalingConstants.growthFactorLimit {
                    self.fadeAndTransform(growthFactor)
                }
                if growthFactor > EVConstants.ScalingConstants.growthFactorLimit {
                    self.fadeAndTransform()
                }
            }
        }
    }
    
    func isPassed(translation translation: CGFloat){
        if isGoingLeft(translation){
            if (leftPosition - EVConstants.ScalingConstants.offset) > (translation + UIScreen.mainScreen().bounds.width) {
                self.fadeAndTransform()
            }
        } else {
            if (rightPosition + EVConstants.ScalingConstants.offset) < translation {
                self.fadeAndTransform()
            }
        }
    }
    
    func replaceOverlay(translation translation: CGFloat, width: CGFloat, growthRate: CGFloat) {
        if isGoingLeft(translation) {
            if case self.leftPosition ... (self.rightPosition + EVConstants.ScalingConstants.buffer) = (width + translation){
                let growthFactor = 1 - calculateGrowthFactorFor(translation: translation, boundsPosition: (width - (self.rightPosition + EVConstants.ScalingConstants.offset)), growthRate: growthRate)
                if growthFactor < EVConstants.ScalingConstants.growthFactorLimit {
                    self.fadeAndTransform(growthFactor)
                }
                if growthFactor > EVConstants.ScalingConstants.growthFactorLimit {
                    self.fadeAndTransform()
                }
            }
        }else{
            if case self.leftPosition ... (self.rightPosition + EVConstants.ScalingConstants.buffer) = translation{
                let growthFactor = 1 - calculateGrowthFactorFor(translation: translation, boundsPosition: (self.leftPosition - EVConstants.ScalingConstants.offset), growthRate: growthRate)
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

//The delegate of a SlidingTableViewCell must adopt the SlidingTableViewCellDelegate protocol.  Methods of this protocol allow the delegate to handle selections and manage the UIButton IBAction's associated with the drawer view.
public protocol SlidingTableViewCellDelegate: class{
    /**
     Set options for DrawerView ContactItem
     - Parameter object: The object used to populate the DrawerViewOptions
     
     - Returns: List of DrawerViewOptions
    */
    func setDrawerViewOptionsForRow(object: Any) -> DrawerViewOptionsType
}


extension SlidingTableViewCellDelegate where Self: UIViewController {
    /**
     Resets Overlay view to center position when the TableViewCell is selected.  You can call this method from didSelectRowAtIndexPath, or you can override.
        
     - Parameter tableView: UITableView used
     - Parameter indexPath: current NSIndexPath
    */
    public func didSelectRowIn(tableView: UITableView, atIndexPath indexPath: NSIndexPath) {
        for cell in tableView.visibleCells as! [SlidingTableViewControllerCell] {
            if cell.drawerDisplayed != nil && cell.drawerDisplayed == true {
                cell.resetOverlay()
                cell.drawerDisplayed = false
            }
        }
    }
}
