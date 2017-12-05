//
//  NewSaleViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/17/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import CoreData

class DateSelectionViewController: UIViewController, UITextFieldDelegate {
    var newSale: GarageSale?
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    //var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageVC = segue.destination as? ImageSelectionViewController {
            newSale?.dateStart = startDatePicker.date
            newSale?.dateEnd = endDatePicker.date
            
            imageVC.newSale = newSale
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}




