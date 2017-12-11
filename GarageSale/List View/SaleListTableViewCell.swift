//
//  SaleListTableViewCell.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/17/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit

class SaleListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! 
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var sale: SaleModel?
    
    func setImagePreview() {
        imagePreview.image = nil
        if let imageData = (sale?.items?.allObjects.first as? ItemModel)?.image {
            let image = UIImage(data: imageData)
            imagePreview.contentMode = .scaleAspectFill
            imagePreview.clipsToBounds = true
            imagePreview.image = image
        }
        imageHeight.constant = addressLabel.frame.height + titleLabel.frame.height + 8
        imagePreview.layer.cornerRadius = imagePreview.frame.height/2.0
    }
}
