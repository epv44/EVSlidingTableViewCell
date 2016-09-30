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
    let reuseIdentifier = "drawerViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: SlidingTableViewControllerCell.classForCoder())
        contactsTableView.register(UINib(nibName: "SlidingTableViewControllerCell", bundle: bundle), forCellReuseIdentifier: reuseIdentifier)
        contactsTableView.rowHeight = UITableViewAutomaticDimension
        contactsTableView.estimatedRowHeight = 71
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        contactsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //delegate method where the default implementation is being used.
        didSelectRowIn(tableView, atIndexPath: indexPath)
    }
    
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) as! SlidingTableViewControllerCell
        let user = data[indexPath.row]
        //set properties for drawer view icons.  In this example they are contact methods
        let contactMethods = setDrawerViewOptionsForRow(object: user)
        //set attributes for the specific UITableViewCell
        cell.setCellWith(overlayParameters: ["name":user.name], drawerViewOptions: contactMethods, overlayView: OverlayView.loadFromNib(nil))
        cell.selectionStyle = .none;
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}

//MARK: - SlidingTableViewCellDelegate
extension ViewController: SlidingTableViewCellDelegate {
    func setDrawerViewOptionsForRow(_ object: Any) -> DrawerViewOptionsType {
        var contactMethods = DrawerViewOptionsType()
        
        if let user = object as? User {
            if let mobileNumber: String = user.homePhone{
                var contactOption = DrawerViewOption()
                contactOption.buttonImage = #imageLiteral(resourceName: "mobile-icon")
                contactOption.textForLabel = "Mobile"
                contactOption.valueForButtonAction = mobileNumber
                contactOption.closure = phoneClosure()
                contactMethods.append(contactOption)
                var contactOptionText = DrawerViewOption()
                contactOptionText.buttonImage = #imageLiteral(resourceName: "text-icon")
                contactOptionText.textForLabel = "Text"
                contactOptionText.valueForButtonAction = mobileNumber
                contactOptionText.closure = textClosure()
                contactMethods.append(contactOptionText)
            }
            if let homePhone: String = user.workPhone{
                var contactOption = DrawerViewOption()
                contactOption.buttonImage = #imageLiteral(resourceName: "home-phone-icon")
                contactOption.textForLabel = "Home"
                contactOption.valueForButtonAction = homePhone
                contactOption.closure = phoneClosure()
                contactMethods.append(contactOption)
            }
            if let email: String = user.email{
                var contactOption = DrawerViewOption()
                contactOption.buttonImage = #imageLiteral(resourceName: "email-icon")
                contactOption.textForLabel = "Email"
                contactOption.valueForButtonAction = email
                contactOption.closure = emailClosure()
                contactMethods.append(contactOption)
            }
        }
        
        return contactMethods
    }
}

