//
//  VerifyDetailsViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/22/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import CoreData

class VerifyDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var newSale: SaleModel?
    var items: [saleItem]?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var itemsCollectionView: UICollectionView! {
        didSet {
            itemsCollectionView.delegate = self
            itemsCollectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressLabel.text = newSale?.address
        startDateLabel.text = newSale?.dateStart?.description
        endDateLabel.text = newSale?.dateEnd?.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    @IBAction func done(_ sender: UIBarButtonItem) {
        newSale?.datePosted = Date()
        let managedObjectContext = newSale!.managedObjectContext!
//        let saleItems = newSale?.mutableSetValue(forKey: "items")
        
        let entityItem = NSEntityDescription.entity(forEntityName: "ItemModel", in: managedObjectContext)
        items?.forEach { saleItem in
            let newItem = ItemModel(entity: entityItem!, insertInto: managedObjectContext)
            let imgData = UIImageJPEGRepresentation(saleItem.image, 0.8)
            newItem.image = imgData
            if let price = saleItem.price {
                newItem.price = price
            }
            newSale?.addToItems(newItem)
//            saleItems?.add(newItem)
        }
        do {
            try self.newSale!.managedObjectContext!.save()
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
