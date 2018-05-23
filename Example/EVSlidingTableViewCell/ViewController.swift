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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.register(SlidingTableViewControllerCell<MyStruct>.self, forCellReuseIdentifier: SlidingTableViewControllerCell<Any>.reuseIdentifier)
        contactsTableView.rowHeight = UITableViewAutomaticDimension
        contactsTableView.estimatedRowHeight = 91
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setDrawerViewOptionsForRow(_ user: User) -> DrawerViewOptionsType {
        var contactMethods = DrawerViewOptionsType()
        
        if let mobileNumber = user.homePhone {
            let contactOption = DrawerViewOption(labelText: "Mobile", actionText: mobileNumber, icon: #imageLiteral(resourceName: "mobile-icon"), action: phoneClosure())
            contactMethods.append(contactOption)
            let contactOptionText = DrawerViewOption(labelText: "Text", actionText: mobileNumber, icon: #imageLiteral(resourceName: "text-icon"), action: textClosure())
            contactMethods.append(contactOptionText)
        }
        if let homePhone = user.workPhone {
            let contactOption = DrawerViewOption(labelText: "Home", actionText: homePhone, icon: #imageLiteral(resourceName: "home-phone-icon"), action: phoneClosure())
            contactMethods.append(contactOption)
        }
        if let email = user.email {
            let contactOption = DrawerViewOption(labelText: "Email", actionText: email, icon: #imageLiteral(resourceName: "email-icon"), action: emailClosure())
            contactMethods.append(contactOption)
        }
        
        return contactMethods
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
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: SlidingTableViewControllerCell<Any>.reuseIdentifier, for: indexPath) as! SlidingTableViewControllerCell<MyStruct>
        let user = data[indexPath.row]
        //set properties for drawer view icons.  In this example they are contact methods
        let contactMethods = setDrawerViewOptionsForRow(user)
        //set attributes for the specific UITableViewCell
        cell.setCellWith(overlayParameters: MyStruct(name: user.name ?? "na"), drawerViewOptions: contactMethods, overlayView: OverlayViewWrapper<MyStruct>())
        cell.selectionStyle = .none;
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}

//MARK: - SlidingTableViewCellDelegate
extension ViewController: SlidingTableViewCellDelegate {
    
}

