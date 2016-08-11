//
//  ViewController.swift
//  EVSlidingTableViewCell
//
//  Created by Eric Vennaro on 08/09/2016.
//  Copyright (c) 2016 Eric Vennaro. All rights reserved.
//

import UIKit
import EVSlidingTableViewCell

class ViewController: UIViewController {
    @IBOutlet weak var contactsTableView: UITableView!
    
    let data = Constants.data
    let reuseIdentifier = "drawViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = NSBundle(forClass: SlidingTableViewControllerCell.classForCoder())
        contactsTableView.registerNib(UINib(nibName: "SlidingTableViewControllerCell", bundle: bundle), forCellReuseIdentifier: reuseIdentifier)
        contactsTableView.rowHeight = UITableViewAutomaticDimension
        contactsTableView.estimatedRowHeight = 71
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        contactsTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        didSelectRowIn(tableView, atIndexPath: indexPath)
    }
    
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier) as! SlidingTableViewControllerCell
        let user = data[indexPath.row]
        let contactMethods = setDrawerViewOptionsForRow(user)
        cell.setCellWithAttributes(overlayParameters: ["name":user.name], drawerViewOptions: contactMethods, overlayView: OverlayView.loadFromNib(nil))
        cell.selectionStyle = .None;
        return cell
    }
}

//MARK: - SlidingTableViewCellDelegate
extension ViewController: SlidingTableViewCellDelegate {
    func setDrawerViewOptionsForRow(object: Any) -> DrawerViewOptionsType {
        var contactMethods = DrawerViewOptionsType()
        
        if let user = object as? User {
            if let mobileNumber: String = user.homePhone{
                var contactOption = DrawerViewOption()
                contactOption.buttonImage = UIImage(imageLiteral: "mobile-icon")
                contactOption.textForLabel = "Mobile"
                contactOption.valueForButtonAction = mobileNumber
                contactOption.closure = phoneClosure()
                contactMethods.append(contactOption)
                var contactOptionText = DrawerViewOption()
                contactOptionText.buttonImage = UIImage(imageLiteral: "text-icon")
                contactOptionText.textForLabel = "Text"
                contactOptionText.valueForButtonAction = mobileNumber
                contactOptionText.closure = textClosure()
                contactMethods.append(contactOptionText)
            }
            if let homePhone: String = user.workPhone{
                var contactOption = DrawerViewOption()
                contactOption.buttonImage = UIImage(imageLiteral: "home-phone-icon")
                contactOption.textForLabel = "Home"
                contactOption.valueForButtonAction = homePhone
                contactOption.closure = phoneClosure()
                contactMethods.append(contactOption)
            }
            if let email: String = user.email{
                var contactOption = DrawerViewOption()
                contactOption.buttonImage = UIImage(imageLiteral: "email-icon")
                contactOption.textForLabel = "Email"
                contactOption.valueForButtonAction = email
                contactOption.closure = emailClosure()
                contactMethods.append(contactOption)
            }
        }
        
        return contactMethods
    }
}

