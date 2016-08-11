# EVSlidingTableViewCell

[![CI Status](http://img.shields.io/travis/Eric Vennaro/EVSlidingTableViewCell.svg?style=flat)](https://travis-ci.org/Eric Vennaro/EVSlidingTableViewCell)
[![Version](https://img.shields.io/cocoapods/v/EVSlidingTableViewCell.svg?style=flat)](http://cocoapods.org/pods/EVSlidingTableViewCell)
[![License](https://img.shields.io/cocoapods/l/EVSlidingTableViewCell.svg?style=flat)](http://cocoapods.org/pods/EVSlidingTableViewCell)
[![Platform](https://img.shields.io/cocoapods/p/EVSlidingTableViewCell.svg?style=flat)](http://cocoapods.org/pods/EVSlidingTableViewCell)

## About

EVSlidingTableViewCell is a custom UITableViewCell that implements the "slide to reveal" functionality similar to GChat.  It supports between 1 and 4 configurable action buttons that are revealed as the user defined Overlay is slid away.

## Usage

To run the sample project, clone the repo, and run `pod install` from the Example directory.

## Requirements

* Swift 2.0+
* iOS 9.0+

## Installation

EVSlidingTableViewCell is available through [CocoaPods][podLink]. To install
it, simply add the following line to your Podfile:

```ruby
pod "EVSlidingTableViewCell"
```

Also include

```ruby
user_frameworks!
```

## Project Description

### EVConstants
Struct that contains constants used in the project.
* **Public**
* **bundle** -> bundle identifier for the pod (EVSlidingTableViewCell)
* **evTableViewCell** -> nib for the UITableViewCell
* **Internal**
* **ScalingConstants** -> internal struct with values pertaining to the DrawerView item animation logic

### ContactItem
UIView that represents one of the drawer view icons which contains a user defined closure that is executed on buttonClick.  Every ContactItem gets its information from a DrawerViewOption.
* **Parameters**
* **labelText** -> sets the text label for the item
* **buttonClosure** -> closure of type ```DrawerViewClosureType```, this closure is executed on buttonClick
* **buttonActionText** -> string utilized in closure
* **labelColor** -> color of the text for the label
* **buttonImage** -> image for the button

### DrawerViewOption
Struct that holds values for a ContactItem.  An array of DrawerViewOptions is constructs based off of the number of ContactItem's one wishes to display in the DrawerView (must be between 1 and 4) and then used to populate the ContactItem UIView.
* **Parameters**
* **closure** -> closure of the type ```DrawerViewClosure``` this is executed on ContactItem's ibAction
* **valueForButtonAction** -> String that is taken as input by the closure
* **textForLabel** -> String that is the text for label displayed by the ContactItem
* **buttonImage** -> UIImage to be displayed on the ContactItem button

### SlidingTableViewControllerCell
UITableViewCell that allows for the Overlay to slide and reveal the drawer.
* **Public Methods**
* **setCellWithAttributes(overlayParameters overlayParameters: OverlayDictionaryType, drawerViewOptions: DrawerViewOptionsType, overlayView overlay: EVOverlayView)**
* Places the ```overlay``` over cell, establishes the drawer view icons as defined by ```drawerViewOptions```, and passes the ```overlayParameters``` to the user defined overlay view.  This action kicks off the UI setup for the overlay view by calling ```setuUI()```.
* **resetOverlay()** resets the overlay view to the center position.


### SlidingTableViewDelegate
Public protocol serving as the delegate for the SlidingTableViewCell, a complete example implementation is included in the sample project.
* **Methods**
* **setDrawerViewOptionsForRow(object: Any) -> DrawerViewOptionsType **
* Use this method to construct an array of DrawerViewOptions this array is then used to populate the ContactItem UIView
* **didSelectRowIn(tableView: UITableView, atIndexPath indexPath: NSIndexPath)**
* Calls ```resetOverlay``` on open cells when a cell is selected
* Has a default implementation that can be overridden

### EVOverlayView
UIView that conforms to the EVOverlayProtocol.  When you create your overlay extend EVOverlay, ```UserOverlay: EVOverlayView```.
* **Parameters**
* **viewParameters** -> ```OverlayDictionaryType``` contains all the user defined properties from the overlayParameters in the ```cell.setCellWithAttributes(...)``` method call 
* **Methods**
* **setupUI()** -> Override this method to set up a custom layout for your overlay view, see OverlayView in sample project for an example implementation

### Extensions
* **UITableView** -> Adds stored property used to check if overlay view is present or hidden
*  **UIView** -> adds method ```.loadFromNib(bundle)``` which is used in the example project and loads a file from a nib see [stackoverflow answer][stackoverflow]

### Typealiases
* **OverlayDictionaryType** -> ```[String:Any?]```
* **DrawerViewOptionType** -> ```[DrawerViewOption]```
* **DrawerViewClosureType** -> ```((String) -> Bool)```
## Getting Started

### 1. Create The Overlay View
Create your custom Overlay View.  This is the view you want to swipe away to reveal the drawer options.  Make sure to override the ```setupUI``` method, because it is called by the DrawerView and allows for the easy setup of the UIAttributes in your cell.  The viewParameters dictionary is available from this method, place the parameters you want in this dictionary and access them to setup your view within the Overlay.

````swift
import EVSlidingTableViewCell
class OverlayView: EVOverlayView {
@IBOutlet private weak var titleLabel: UILabel!
//override this method
override func setupUI(){
titleLabel.text = viewParameters["titleLabelText"]
}
}
````

### 2. Register Cell In View Controller

After creating the overlay view register the cell to the UITableView.

````swift
tableView.registerNib(EVConstants.evTableViewCell, forCellReuseIdentifier: reuseIdentifier)
````

Extend the SlidingTableViewCellDelegate and implement the ```setDrawerViewOptionsForRow``` method 

````swift
extension ViewController: SlidingTableViewCellDelegate {
//there is a more robust example inside the example project
func setDrawerViewOptionsForRow(object: Any) -> DrawerViewOptionsType {
var contactMethods = DrawerViewOptionsType()
//set contactMethods values for the label, image, and closure...
//e.i. contactMethods.closure = emailClosure()

return contactMethods 
}
}
````

Make sure to correctly link to this cell inside of your UITableViewDelegate/DataSource

````swift
//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//calls delegate method to replace overlay you can overwrite this method inside of the SlidingTableViewCellDelegate
didSelectRowIn(tableView, atIndexPath: indexPath)
}
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
let cell = contactsTableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier) as! SlidingTableViewControllerCell
let user = data[indexPath.row]
//calls delegateMethod
let contactMethods = setDrawerViewOptionsForRow(user)
cell.setCellWithAttributes(overlayParameters: [:], drawerViewOptions: contactMethods, overlayView: OverlayView.loadFromNib(nil))
cell.selectionStyle = .None;
return cell
}
}
````

Lastly, define your closures which are executed on drawer view button click. Make sure they conform to the ```DrawerViewClosureType```.  Feel free to make whatever closures you want.  Sticking with the GChat theme, examples are included below:

````swift
func emailClosure() -> DrawerViewClosureType {
func openEmail(text: String) -> (Bool) {
UIApplication.sharedApplication().openURL(NSURL(string: "mailto:\(text)")!)
return true
}

return openEmail
}


func phoneClosure() -> DrawerViewClosureType {
func openPhone(text: String) -> (Bool) {
let phoneNumber: String = text.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber)")!)
return true
}

return openPhone
}

func textClosure() -> DrawerViewClosureType {
func openMessenger(text: String) -> (Bool) {
let phoneNumber = text.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
UIApplication.sharedApplication().openURL(NSURL(string: "sms:+\(phoneNumber)")!)
return true
}

return openMessenger
}
````

## Author

Eric Vennaro, epv9@case.edu

## License

EVSlidingTableViewCell is available under the [MIT License][mitLink]. See the LICENSE file for more info.
>**Copyright &copy; 2016-present Eric Vennaro.**

[img0]:https://raw.githubusercontent.com/epv44/EVTopTabBar/master/tabBar.gif
[podLink]:http://cocoapods.org
[blogLink]:http://www.ericvennaro.com
[mitLink]:http://opensource.org/licenses/MIT
[stackoverflow]:http://stackoverflow.com/questions/25513271/how-to-initialise-a-uiview-class-with-a-xib-file-in-swift-ios
