//
//  VerifyDetailsCollectionViewCell.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/22/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit

class VerifyDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var priceLabel: PaddedLabel!
    
    func setPriceLabel(to price: Float?) {
        priceLabel.text = price?.priceString
        priceLabel.layer.cornerRadius = GlobalConstants.labelCornerRadius
        priceLabel.backgroundColor = GlobalConstants.labelBackgroundColor
        priceLabel.layer.masksToBounds = true
    }
}
