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

    var address: String?
    var latitude: Double?
    var longitude: Double?
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    // MARK: - Navigation Actions
    
    //var creationCompletionHandler:(() -> Void)?
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        let sale = SaleModel(context: managedObjectContext)
        
        if address == nil || latitude == nil || longitude == nil {
            return
        }
        
        sale.address = address!
        sale.latitude = latitude!
        sale.longitude = longitude!
        sale.dateStart = startDatePicker.date
        sale.dateEnd = endDatePicker.date
        sale.datePosted = Date()
        sale.id = UUID()
        
        do {
            try self.managedObjectContext.save()
            print("successfully saved data")
            resetView()
            //creationCompletionHandler?()
            //self.dismiss(animated: true, completion: nil)
            
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    private func resetView() {
        self.tabBarController?.switchToTab(0, withAnimation: true)
        self.navigationController?.popToRootViewController(animated: false)
        if let mapVC = self.navigationController?.viewControllers.first as? LocationSelectionViewController {
            mapVC.setMapLocationToUser()
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


extension UITabBarController {
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




