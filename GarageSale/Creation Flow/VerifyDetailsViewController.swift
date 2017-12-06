//
//  VerifyDetailsViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/22/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import CoreData

class VerifyDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var newSale: GarageSale?
    var items: [SaleItem]?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var itemsCollectionView: UICollectionView! {
        didSet {
            itemsCollectionView.delegate = self
            itemsCollectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressLabel.text = newSale?.address
        dateLabel.text = newSale?.date?.dateString
        timeLabel.text = timeRangeString(newSale?.timeStart, to: newSale?.timeEnd)
    }
    
    // MARK: - CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsCollectionView.dequeueReusableCell(withReuseIdentifier: "VerifyItemCell", for: indexPath)
        if let itemCell = cell as? VerifyDetailsCollectionViewCell, let item = items?[indexPath.row] {
            itemCell.itemImageView.image = item.image
            itemCell.priceLabel.text = item.price?.priceString
        }
        return cell
    }
    

    var checkedAction: UIAlertAction?
    @IBAction func done(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: "What would you like your garage sale to be called?", preferredStyle: .alert)
        weak var weakSelf = self
        alert.addTextField(configurationHandler: {
            $0.placeholder = "Garage Sale Name"
            $0.addTarget(weakSelf!, action: #selector(weakSelf!.textFieldChanged(_:)), for: .editingChanged)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let create = UIAlertAction(title: "Create", style: .default) { action in
            if let title = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces) {
                weakSelf?.createSale(with: title)
            }
        }
        checkedAction = create
        checkedAction?.isEnabled = false
        alert.addAction(cancel)
        alert.addAction(create)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func textFieldChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            checkedAction?.isEnabled = false
        } else {
            checkedAction?.isEnabled = true
        }
    }
    
    private func createSale(with title: String) {
        newSale?.title = title
        newSale?.datePosted = Date()
        newSale?.items = items
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try newSale?.save(withManagedObjectContext: managedObjectContext)
            print("successfully saved data")
            resetView()
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

}
