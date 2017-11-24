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
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    func setImageView(with imgData: Data) {
        guard let image = UIImage(data: imgData)
            else { return }
        
        let background = UIImageView(frame: self.frame)
        background.image = image
        background.clipsToBounds = true
        background.contentMode = .scaleAspectFill
        background.alpha = 0.5
        addSubview(background)
        sendSubview(toBack: background)
        
        itemImageView.image = image
        itemImageView.contentMode = .scaleAspectFit
    }
}
