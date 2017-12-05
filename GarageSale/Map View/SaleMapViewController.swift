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

class SaleMapViewController: MapSearchViewController, MKMapViewDelegate {

    @IBOutlet weak var saleMap: MKMapView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        saleMap.delegate = self
        saleMap.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
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
            
            //let annotation = MKAnnotation()
            
            //annotation.coordinate =
            //let coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            //let annotation = SaleAnnotation(title: "Title", subtitle: "subtitle", coordinate: coordinate)
            //annotation.subtitle = $0.address
            let annotation = SaleAnnotation(sale: $0)
            saleMap.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let annotation = annotation as? SaleAnnotation else { return nil }
        let view: MKMarkerAnnotationView
        
        if let dqdView = mapView.dequeueReusableAnnotationView(withIdentifier: MapConstants.REUSE_PIN_IDENTIFIER) as? MKMarkerAnnotationView {
            dqdView.annotation = annotation
            view = dqdView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MapConstants.REUSE_PIN_IDENTIFIER)
            view.canShowCallout = true
            
            let infoBtn = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = infoBtn
            view.sizeToFit()
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? SaleAnnotation else { return }
        print("\(annotation.title) touched")
    }
    
    private struct MapConstants {
        static let REUSE_PIN_IDENTIFIER = "calloutPin"
    }
}
