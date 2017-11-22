//
//  AddItemCollectionViewCell.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/21/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit

class AddItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var priceTextField: UITextField! {
        didSet {
            priceTextField.addDoneCancelToolbar()
        }
    }
}

/* UITextField extension adapted from
 * https://stackoverflow.com/questions/38133853/how-to-add-a-return-key-on-a-decimal-pad-in-swift
 */
extension UITextField {
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
