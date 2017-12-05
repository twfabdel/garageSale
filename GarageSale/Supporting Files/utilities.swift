//
//  utilities.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/23/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import CoreLocation
import UIKit

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
