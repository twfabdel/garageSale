//
//  SaleMapViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/17/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class SaleMapViewController: MapSearchViewController {

    @IBOutlet weak var saleMap: MKMapView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        super.map = saleMap
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPins()
    }
    
    // MARK: - Load Core Data
    
    private func loadPins() {
        let saleRequest: NSFetchRequest<SaleModel> = SaleModel.fetchRequest()
        
        do {
            let garageSales = try managedObjectContext.fetch(saleRequest)
            placePins(of: garageSales)
        } catch {
            print("Could not load data: \(error.localizedDescription)")
        }
    }
  
    // MARK: - Annotations
    
    private func placePins(of sales: [SaleModel]) {
        saleMap.removeAnnotations(saleMap.annotations)
        sales.forEach {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            annotation.subtitle = $0.address
            saleMap.addAnnotation(annotation)
        }
    }
    
}
