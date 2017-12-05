//
//  SaleListTableViewCell.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/17/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit

class SaleListTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var sale: SaleModel?
}
