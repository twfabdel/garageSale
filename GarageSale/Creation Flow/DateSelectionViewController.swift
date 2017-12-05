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
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        startTimePicker.addTarget(self, action: #selector(startTimeChanged(_:)), for: .valueChanged)
        startTimeChanged(startTimePicker)
    }
    
    @objc func startTimeChanged(_ picker: UIDatePicker) {
        endTimePicker.setDate(picker.date.addingTimeInterval(1.0 * 60.0 * 60.0), animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageVC = segue.destination as? ImageSelectionViewController {
            newSale?.date = datePicker.date
            newSale?.timeStart = startTimePicker.date
            newSale?.timeEnd = endTimePicker.date
            
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




