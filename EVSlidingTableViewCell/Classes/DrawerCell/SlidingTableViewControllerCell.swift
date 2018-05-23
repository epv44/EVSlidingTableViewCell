//
//  SlidingTableViewControllerCell.swift
//  SlidingTableViewCell
//
//  Created by Eric Vennaro on 7/25/16.
//  Copyright © 2016 Eric Vennaro. All rights reserved.
//

import UIKit

public typealias DrawerViewOptionsType = [DrawerViewOption]
public typealias DrawerViewClosureType = ((String) -> Bool)

/**
 UITableViewCell that takes a user defined overlay view and allows it to be "swiped" away revealing a serious of IBAction buttons.  As the drawer option buttons are revealed they grow and fade in.
 */
public extension SlidingTableViewControllerCell {
    public static var reuseIdentifier: String {
        return "drawerViewCell"
    }
}
open class SlidingTableViewControllerCell<T>: UITableViewCell {
    fileprivate lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 40
        stackView.contentMode = .scaleToFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    fileprivate var overlayViewGestureRecognizer: UIPanGestureRecognizer?
    fileprivate var drawerViewGestureRecognizer: UIPanGestureRecognizer?
    fileprivate var drawerBoxes = [ContactItem]()
    fileprivate var originalCenter: CGPoint?
    fileprivate var growthRate: CGFloat = 0.01
    fileprivate weak var overlayView: EVOverlayView<T>? {
        didSet {
            overlayViewGestureRecognizer = UIPanGestureRecognizer(target: self, action: .handlePanFromOverlay)
            drawerViewGestureRecognizer = UIPanGestureRecognizer(target:self, action: .handlePanFromDrawer)
            overlayViewGestureRecognizer?.delegate = self
            drawerViewGestureRecognizer?.delegate = self
            overlayView?.addGestureRecognizer(overlayViewGestureRecognizer!)
            addGestureRecognizer(drawerViewGestureRecognizer!)
        }
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Set UIAttributes for DrawerView, establish gesture recognizers, and add the user defined overlay to the drawer.
     
        - Parameter overlayParameters: Dictionary [String:Any?] that is passed to the user defined overlay upon setup.  Users should store any parameters they need to set the UI of their overlay and then access this dictionary inside the setupUI() method of their overlay.
        - Parameter drawerViewOptions: List of DrawerViewOption's which apply to the cell being set up.  These parameters are used to load the layout of the DrawerView options.
        - Parameter overlayView: User defined overlay for the cell, of type EVOverlayView which extends UIView
    */
    open func setCellWith(overlayParameters: T, drawerViewOptions: DrawerViewOptionsType, overlayView overlay: EVOverlayView<T>){
        contentView.addSubview(containerView)
        containerView.pinTo(view: contentView)
        
        if overlayView != nil {
            overlayView?.removeFromSuperview()
            overlayView  = nil
        }
        overlayView = overlay
        contentView.addSubview(overlayView!)
        overlayView?.translatesAutoresizingMaskIntoConstraints = false
        overlayView?.pinTo(view: contentView)
        setupDrawerViewUI(options: drawerViewOptions)
        setGrowthRate()
        overlayView?.viewParameters = overlayParameters
    }
    
    ///Removes overlay from the superview including gestures
    open func clear() {
        removeGestures()
        overlayView?.removeFromSuperview()
        overlayView = nil
    }
    
    ///Sets overlay to original center position, fully covering the drawer view.
    /// - Parameter animated: decide if you want the overlay to animate back into position or just appear back on top
    open func resetOverlay(animated: Bool = false) {
        guard let originalCenter = originalCenter else {
            NSLog("Cannot reset to center, original center was never set")
            return
        }
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn,
                animations: {
                    self.overlayView?.center = originalCenter
                }, completion: nil)
        } else {
            overlayView?.center = originalCenter
        }
    }
    
    ///Removes gestures from the view
    open func removeGestures() {
        overlayView?.removeFromSuperview()
        if overlayViewGestureRecognizer != nil && drawerViewGestureRecognizer != nil {
            overlayViewGestureRecognizer?.view?.removeGestureRecognizer(overlayViewGestureRecognizer!)
            drawerViewGestureRecognizer?.view?.removeGestureRecognizer(drawerViewGestureRecognizer!)
        }
    }
    
    //MARK: Gesture Handlers
    @objc fileprivate func handlePanFromOverlay(_ recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: overlayView)
        switch recognizer.state {
        case .began:
            originalCenter = overlayView?.center
            resetCells(except: self)
            break
        case .changed:
            overlayView?.center = CGPoint(x: (originalCenter?.x)! + translation.x, y: (originalCenter?.y)!)
            drawerBoxes.forEach { view in
                view.withdrawOverlay(translation: translation.x, width: (overlayView?.bounds.width)!, growthRate: growthRate)
                let range = frame.size.height - view.frame.size.height
                if range > 10 {
                    view.isPassed(translation: translation.x)
                }
            }
            break
        case .ended:
            let originalFrame = CGRect(x: 0, y: 0, width: contentView.bounds.size.width, height: contentView.bounds.size.height)
            if(abs(translation.x) > (overlayView?.frame.size.width)!/4) {
                drawerDisplayed = true
                if isGoingLeft(translation.x) {
                    UIView.animate(withDuration: 0.2,
                        animations: {
                            self.overlayView?.frame.origin.x = -(self.contentView.frame.size.width + 10)
                        }
                    )
                } else {
                    UIView.animate(withDuration: 0.2,
                        animations: {
                            self.overlayView?.frame.origin.x = (self.contentView.frame.size.width + 10)
                        }
                    )
                }
                drawerBoxes.forEach { view in
                    view.fadeAndTransform()
                }
            }else{
                drawerDisplayed = false
                UIView.animate(withDuration: 0.2, animations: { self.overlayView?.frame = originalFrame })
            }
            break
        default:
            break
        }
    }
    
    @objc fileprivate func handlePanFromDrawer(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.overlayView)
        switch recognizer.state {
        case .changed:
            drawerBoxes.forEach { view in
                view.replaceOverlay(translation: translation.x, width: (overlayView?.bounds.width)!, growthRate: growthRate)
            }
            let xPosition = isGoingLeft(translation.x) ? (overlayView?.bounds.origin.x)! + (overlayView?.frame.width)! : (overlayView?.bounds.origin.x)! - (overlayView?.frame.width)!
            overlayView?.frame = CGRect(x: xPosition + translation.x, y: 0, width: (overlayView?.frame.width)!, height: (overlayView?.frame.height)!)
            break
        case .ended:
            UIView.animate(withDuration: 0.5,
                animations: {
                    self.overlayView?.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
                }
            )
            drawerDisplayed = false
            break
        default:
            break
        }
    }
    
    ///Set gesture recognizer to only pick up on horizontal swipes and allow for normal vertical scrolling of the UITableView
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        let translation = panGestureRecognizer.translation(in: superview!)
        return fabs(translation.x) > fabs(translation.y)
    }
    
    //MARK: Private Methods
    fileprivate func setupDrawerViewUI(options drawerViewOptions: DrawerViewOptionsType){
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        drawerBoxes = []
        if drawerViewOptions.count < 5 {
            drawerViewOptions.forEach { [weak self] option in
                let contactView = ContactItem.loadFromNib(Bundle(for: ContactItem.classForCoder()))
                contactView.buttonImage = option.icon
                contactView.labelText = option.labelText
                contactView.buttonClosure = option.actionClosure
                contactView.buttonActionText = option.associateContactValue
                containerView.addArrangedSubview(contactView)
                self?.drawerBoxes.append(contactView)
            }
        }
    }
    
    fileprivate func roundTo(places: Int, with value: Double) -> Double {
        let divisor = pow(10.0, Double(places))
        return ceil(value * divisor) / divisor
    }
    
    fileprivate func setGrowthRate() {
        let numberOfDrawerBoxes = drawerBoxes.count
        if numberOfDrawerBoxes != 0 {
            let rawRate = Double((1.0 / (UIScreen.main.bounds.width / CGFloat(numberOfDrawerBoxes))))
            growthRate = CGFloat(roundTo(places: 3, with: rawRate))
        }
    }
    
    private func resetCells(except currentCell: SlidingTableViewControllerCell) {
        guard let tableView = superview as? UITableView else {
            NSLog("Error: superview is not a Table view")
            return
        }
        
        for cell in tableView.visibleCells {
            guard let slidingCell = cell as? SlidingTableViewControllerCell else {
                break
            }
            
            if slidingCell.drawerDisplayed != nil && cell.drawerDisplayed == true && slidingCell !== currentCell {
                slidingCell.resetOverlay(animated: true)
                slidingCell.drawerDisplayed = false
            }
        }
    }
}

// MARK: Selector
private extension Selector {
    static let handlePanFromOverlay = #selector(SlidingTableViewControllerCell<Any>.handlePanFromOverlay(_:))
    static let handlePanFromDrawer = #selector(SlidingTableViewControllerCell<Any>.handlePanFromDrawer(_:))
}

// MARK: UIView
private extension UIView {
    var leftPosition: CGFloat { return (center.x - (frame.width / 2)) }
    var rightPosition: CGFloat { return (center.x + (frame.width / 2)) }
    
    func fadeAndTransform(_ changeFactor: CGFloat = 1.0) {
        self.alpha = changeFactor < 0.3 ? 0.3 : changeFactor
        self.transform = CGAffineTransform(scaleX: changeFactor, y: changeFactor)
    }
    
    func setStartingState(_ alphaValue: CGFloat = 0.0, transformValue: CGFloat = 0.2) {
        self.alpha = alphaValue
        self.transform = CGAffineTransform(scaleX: transformValue, y: transformValue)
    }
    
    func withdrawOverlay(translation: CGFloat, width: CGFloat, growthRate: CGFloat) {
        if isGoingLeft(translation){
            if case ((leftPosition) - EVConstants.ScalingConstants.buffer) ... rightPosition = (translation + width) {
                let growthFactor = calculateGrowthFactorFor(translation: translation, boundsPosition: (width - (rightPosition + EVConstants.ScalingConstants.offset)), growthRate: growthRate)
                if growthFactor < EVConstants.ScalingConstants.growthFactorLimit {
                    fadeAndTransform(growthFactor)
                }
                if growthFactor > EVConstants.ScalingConstants.growthFactorLimit {
                    fadeAndTransform()
                }
            }
        } else {
            if case leftPosition ... (rightPosition + EVConstants.ScalingConstants.buffer) = translation {
                let growthFactor = calculateGrowthFactorFor(translation: translation, boundsPosition: (leftPosition - EVConstants.ScalingConstants.offset), growthRate: growthRate)
                if growthFactor < EVConstants.ScalingConstants.growthFactorLimit {
                    fadeAndTransform(growthFactor)
                }
                if growthFactor > EVConstants.ScalingConstants.growthFactorLimit {
                    fadeAndTransform()
                }
            }
        }
    }
    
    func isPassed(translation: CGFloat){
        if isGoingLeft(translation) && (leftPosition - EVConstants.ScalingConstants.offset) > (translation + UIScreen.main.bounds.width) {
            fadeAndTransform()
        } else if (rightPosition + EVConstants.ScalingConstants.offset) < translation {
            fadeAndTransform()
        }
    }
    
    func replaceOverlay(translation: CGFloat, width: CGFloat, growthRate: CGFloat) {
        if isGoingLeft(translation) {
            if case leftPosition ... (rightPosition + EVConstants.ScalingConstants.buffer) = (width + translation){
                let growthFactor = 1 - calculateGrowthFactorFor(translation: translation, boundsPosition: (width - (rightPosition + EVConstants.ScalingConstants.offset)), growthRate: growthRate)
                if growthFactor < EVConstants.ScalingConstants.growthFactorLimit {
                    fadeAndTransform(growthFactor)
                }
                if growthFactor > EVConstants.ScalingConstants.growthFactorLimit {
                    fadeAndTransform()
                }
            }
        }else{
            if case leftPosition ... (rightPosition + EVConstants.ScalingConstants.buffer) = translation{
                let growthFactor = 1 - calculateGrowthFactorFor(translation: translation, boundsPosition: (leftPosition - EVConstants.ScalingConstants.offset), growthRate: growthRate)
                fadeAndTransform(growthFactor)
            }
        }
    }
    
    func isGoingLeft(_ value: CGFloat) -> Bool{
        return value < 0
    }
    
    func calculateGrowthFactorFor(translation: CGFloat, boundsPosition: CGFloat, growthRate: CGFloat) -> CGFloat {
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

//MARK: Delegate
/**
 The delegate of a SlidingTableViewCell must adopt the SlidingTableViewCellDelegate protocol.  Methods of this protocol allow the delegate to handle selections and manage the UIButton IBAction's associated with the drawer view.
 */
public protocol SlidingTableViewCellDelegate: class {
    /**
     Resets Overlay view to center position when the TableViewCell is selected.  You can call this method from didSelectRowAtIndexPath, or you can override.
     
     - Parameter tableView: UITableView used
     - Parameter indexPath: current NSIndexPath
     */
    func didSelectRowIn(_ tableView: UITableView, atIndexPath indexPath: IndexPath)
}


extension SlidingTableViewCellDelegate where Self: UIViewController {
    /**
     Resets Overlay view to center position when the TableViewCell is selected.  You can call this method from didSelectRowAtIndexPath, or you can override.
        
     - Parameter tableView: UITableView used
     - Parameter indexPath: current NSIndexPath
    */
    public func didSelectRowIn(_ tableView: UITableView, atIndexPath indexPath: IndexPath) {
        guard let cells = tableView.visibleCells as? [SlidingTableViewControllerCell<Any>] else { return }
        for cell in cells {
            if cell.drawerDisplayed != nil && cell.drawerDisplayed == true {
                cell.resetOverlay(animated: true)
                cell.drawerDisplayed = false
            }
        }
    }
}
