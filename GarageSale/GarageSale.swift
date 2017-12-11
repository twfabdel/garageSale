//
//  GarageSale.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 12/4/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import CoreData

public struct GarageSale {
    var address: String?
    var title: String?
    var date: Date?
    var timeStart: Date?
    var timeEnd: Date?
    var datePosted: Date?
    var latitude: Double?
    var longitude: Double?
    
    var items: [SaleItem]?
    
    func save(withManagedObjectContext managedObjectContext: NSManagedObjectContext) throws {
        let newSale = SaleModel(context: managedObjectContext)
        if !setAttributes(on: newSale) {
            throw "Missing fields"
        }
        let entityItem = NSEntityDescription.entity(forEntityName: "ItemModel", in: managedObjectContext)
        items?.forEach { saleItem in
            let newItem = ItemModel(entity: entityItem!, insertInto: managedObjectContext)
            let imgData = UIImageJPEGRepresentation(saleItem.image, 0.8)
            newItem.image = imgData
            if let price = saleItem.price {
                newItem.price = price
            }
            newSale.addToItems(newItem)
        }
        try newSale.managedObjectContext!.save()
    }
    
    private func setAttributes(on sale: SaleModel) -> Bool {
        guard let newAddress = address,
            let newDate = date,
            let newTitle = title,
            let newLatitude = latitude,
            let newLongitude = longitude,
            let newTimeStart = newDate.getDate(withTime: timeStart),
            let newTimeEnd = newDate.getDate(withTime: timeEnd)
            else { return false }
        sale.address = newAddress
        sale.timeStart = newTimeStart
        sale.timeEnd = newTimeEnd
        sale.date = newDate
        sale.datePosted = Date()
        sale.latitude = newLatitude
        sale.longitude = newLongitude
        sale.title = newTitle
        return true
    }
}

extension String: Error{}
