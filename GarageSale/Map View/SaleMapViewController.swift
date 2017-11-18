//
//  SaleMapViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/17/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import MapKit

class SaleMapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager()
    var resultSearchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        setMapLocationToUser()
        
        if let saleSearchTable = storyboard?.instantiateViewController(withIdentifier: "MapSearchTable") as? MapSearchTableViewController {
            resultSearchController = UISearchController(searchResultsController: saleSearchTable)
            resultSearchController.searchResultsUpdater = saleSearchTable
            
            let searchBar = resultSearchController!.searchBar
            searchBar.sizeToFit()
            searchBar.placeholder = "Search for garage sales near:"
            
            navigationItem.titleView = resultSearchController?.searchBar
            resultSearchController.hidesNavigationBarDuringPresentation = false
            resultSearchController.dimsBackgroundDuringPresentation = true
//            definesPresentationContext = true
            
        }
        
       
    }
    
    // MARK: - Map and location
    
    func setMapLocationToUser() {
        if let location = manager.location {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let locationCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            map.setRegion(MKCoordinateRegion(center: locationCoordinate, span: span), animated: true)
            map.showsUserLocation = true
        }
    }
}
