//
//  ItemImagesViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/24/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit

class ItemImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var saleItems: [Any]?
    
    override func viewDidLoad() {
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
    }
    
    @objc private func dismissView(_ sender: UISwipeGestureRecognizer) {
        if sender.state != .ended {
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var itemImagesCollectionView: UICollectionView! {
        didSet {
            itemImagesCollectionView.delegate = self
            itemImagesCollectionView.dataSource = self
        }
    }
    
    // MARK: - CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return sale?.items?.count ?? 0
        return saleItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "SaleDetailCell", for: indexPath)
        
        if let detailCell = cell as? SaleDetailsCollectionViewCell,
            //let itemsSet = sale?.items,
            //let item = itemsSet.allObjects[indexPath.row] as? ItemModel,
            let item = saleItems?[indexPath.row] as? ItemModel,
            let itemImageData = item.image
        {
            detailCell.itemPriceLabel.text = item.price.priceString
            detailCell.itemImageView.image = UIImage(data: itemImageData)
        }
        
        return cell
    }

}
