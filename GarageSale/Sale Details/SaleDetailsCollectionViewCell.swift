//
//  SaleDetailsCollectionViewCell.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/23/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit

class SaleDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!

    
    func setImageView(with imgData: Data) {
        guard let image = UIImage(data: imgData)
            else { return }
        
        itemImageView.image = image
        itemImageView.contentMode = .scaleAspectFit
        
        backgroundImageView.image = image
        backgroundImageView.clipsToBounds = true
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.25
        sendSubview(toBack: backgroundImageView)
    }
}
