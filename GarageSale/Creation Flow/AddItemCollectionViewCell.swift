//
//  AddItemCollectionViewCell.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/21/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit

class AddItemCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var priceTextField: UITextField! {
        didSet {
            priceTextField.addDoneCancelToolbar()
            priceTextField.delegate = self
        }
    }
    
    var priceEditedHandler: (() -> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        priceEditedHandler?()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.first == "$" {
            textField.text?.remove(at: textField.text!.startIndex)
        }
    }
}
