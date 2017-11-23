//
//  SaleDetailsViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/23/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit

class SaleDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var sale: SaleModel?

    @IBOutlet weak var saleDetailsCollectionView: UICollectionView! {
        didSet {
            saleDetailsCollectionView.delegate = self
            saleDetailsCollectionView.dataSource = self
        }
    }
    
    // MARK: - CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sale?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = saleDetailsCollectionView.dequeueReusableCell(withReuseIdentifier: "SaleDetailCell", for: indexPath)
        
        if let detailCell = cell as? SaleDetailsCollectionViewCell,
            let itemsSet = sale?.items,
            let item = itemsSet.allObjects[indexPath.row] as? ItemModel,
            let itemImageData = item.image
        {
            detailCell.itemPriceLabel.text = item.price.priceString
            detailCell.itemImageView.image = UIImage(data: itemImageData)
        }
        
        return cell
    }
}
