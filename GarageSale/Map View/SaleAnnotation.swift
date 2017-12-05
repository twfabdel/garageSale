//
//  SaleAnnotation.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 12/2/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import MapKit

class SaleAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var sale: SaleModel?
    
    //init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
//        self.title = title
//        self.subtitle = subtitle
    init(sale: SaleModel) {
        self.coordinate = CLLocationCoordinate2D(latitude: sale.latitude, longitude: sale.longitude)
        self.sale = sale
        self.title = sale.address
        super.init()
    }
}
