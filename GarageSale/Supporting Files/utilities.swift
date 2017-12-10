//
//  utilities.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/23/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import CoreLocation
import UIKit

public struct GlobalConstants {
    static let labelCornerRadius: CGFloat = 8.0
    static let labelBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8)
    static let labelYInset: CGFloat = 5.0
    static let labelXInset: CGFloat = 8.0
    
    static let primaryColor = #colorLiteral(red: 0.6513273403, green: 0.366730796, blue: 0.7063275263, alpha: 1)
    static let darkPrimaryColor = #colorLiteral(red: 0.3615243779, green: 0.2035568211, blue: 0.392052665, alpha: 1)
    static let secondaryColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
    static let barTextColor = UIColor.white
    
    static let IconMap: [(string: String, image: UIImage)] = [
        ("Soonest", #imageLiteral(resourceName: "date_icon")),
        ("Newest", #imageLiteral(resourceName: "recently_added_icon")),
        ("Nearest", #imageLiteral(resourceName: "distance_icon")),
        ("Cheapest", #imageLiteral(resourceName: "price_icon"))
    ]
}

public enum SortIcons: Int {
    case Soonest;
    case Newest;
    case Nearest;
    case Cheapest;
    
    static let count = 4
    
    func getImage() -> UIImage {
        switch self {
        case .Soonest:
            return #imageLiteral(resourceName: "date_icon")
        case .Newest:
            return #imageLiteral(resourceName: "recently_added_icon")
        case .Nearest:
            return #imageLiteral(resourceName: "distance_icon")
        case .Cheapest:
            return #imageLiteral(resourceName: "price_icon")
        }
    }
    
    func getString() -> String {
        switch self {
        case .Soonest:
            return "Soonest"
        case .Newest:
            return "Newest"
        case .Nearest:
            return "Nearest"
        case .Cheapest:
            return "Cheapest"
        }
    }
}

class PoppingTabBar: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        delegate = self
        self.tabBar.barTintColor = GlobalConstants.primaryColor
        self.tabBar.tintColor = GlobalConstants.secondaryColor
        self.tabBar.unselectedItemTintColor = GlobalConstants.barTextColor
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): GlobalConstants.barTextColor],
            for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): GlobalConstants.secondaryColor],
            for: .selected)
        super.viewDidLoad()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navVC = viewController as? UINavigationController {
            navVC.popToRootViewController(animated: false)
        }
    }
}

class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        self.navigationBar.barTintColor = GlobalConstants.primaryColor
        self.navigationBar.tintColor = GlobalConstants.barTextColor
        self.navigationBar.titleTextAttributes = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): GlobalConstants.barTextColor,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 28)
        ]
        super.viewDidLoad()
    }
}

class PaddedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insetX = GlobalConstants.labelXInset
        let insetY = GlobalConstants.labelYInset
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += 2*GlobalConstants.labelYInset
            contentSize.width += 2*GlobalConstants.labelXInset
            return contentSize
        }
    }
}

public func timeRangeString(_ start: Date?, to end: Date?) -> String {
    var result = ""
    if let start = start {
        result += start.timeString
        if let end = end {
            result += (" - " + end.timeString)
        }
    }
    return result
}

public func saleToString(sale: SaleModel) -> String {
    var result = ""
    if let title = sale.title {
        result += "\(title) "
    }
    if let address = sale.address {
        result += "at \(address) "
    }
    if let date = sale.date {
        result += "on \(date.dateString) "
    }
    result += timeRangeString(sale.timeStart, to: sale.timeEnd)
    return result
}

public extension Float {
    var priceString: String {
        return String(format: "$%.02f", self)
    }
}

public extension Date {
    var fullFormattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy h:mm a"
        return formatter.string(from: self)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: self)
    }
    
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter.string(from: self)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
}

/* UITextField extension adapted from
 * https://stackoverflow.com/questions/38133853/how-to-add-a-return-key-on-a-decimal-pad-in-swift
 */
public extension UITextField {
    func addDoneCancelToolbar() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        ]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        self.resignFirstResponder()
    }
}

public extension UITabBarController {
    func switchToTab(_ index: Int, withAnimation animated: Bool) {
        if !animated {
            self.selectedIndex = index
            return
        }
        if let fromView = self.selectedViewController?.view, let toView = self.viewControllers?[index].view {
            UIView.transition(
                from: fromView,
                to: toView,
                duration: 0.60,
                options: .transitionCurlDown ,
                completion: { finished in
                    if finished {
                        self.selectedIndex = index
                    }
            }
            )
        }
    }
}

public extension CLPlacemark {
    var addressString: String {
        var address = append(subThoroughfare, to: "")
        address = append(thoroughfare, to: address, with: " ")
        address = append(locality, to: address, with: ", ")
        address = append(administrativeArea, to: address, with: ", ")
        return address
    }
    
    private func append(_ str: String?, to address: String, with delimiter: String = "") -> String {
        if str == nil {
            return address
        }
        if address.isEmpty {
            return str!
        }
        return address + delimiter + str!
    }
    
    private func addComma(to string: String) -> String {
        if string.count == 0 {
            return string
        }
        if string.suffix(2) == ", " {
            return string
        }
        return string + ", "
    }
    
    private func addSpace(to string: String) -> String {
        if string.count == 0 {
            return string
        }
        if string.suffix(1) == " " {
            return string
        }
        return string + " "
    }
}
